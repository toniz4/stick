defmodule Stick.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Stick.Roles.Role
  alias Stick.Units.Unit
  alias Stick.Units.Department

  schema "users" do
    field :email, :string
    field :username, :string
    field :name, :string
    field :password, :string, virtual: true, redact: true
    field :hashed_password, :string, redact: true
    field :confirmed_at, :naive_datetime
    field :enabled, :boolean, default: true
    belongs_to :role, Role, on_replace: :nilify
    belongs_to :unit, Unit, on_replace: :nilify
    belongs_to :department, Department, on_replace: :nilify

    timestamps()
  end

  @doc """
  A user changeset for registration.

  It is important to validate the length of both email and password.
  Otherwise databases may truncate the email without warnings, which
  could lead to unpredictable or insecure behaviour. Long passwords may
  also be very expensive to hash for certain algorithms.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:email, :password, :name, :username, :enabled])
    |> assoc_constraint(:role)
    |> get_assoc(:unit, attrs)
    |> get_assoc(:role, attrs)
    |> get_assoc(:department, attrs)
    |> validate_username()
    |> validate_name()
    |> validate_email()
    |> validate_password(opts)
  end

  def get_assoc(changeset, :unit, attrs) do
    unit =
      changeset
      |> get_unit_assoc(attrs)

    changeset
    |> put_assoc(:unit, unit)
  end

  def get_assoc(changeset, :role, attrs) do
    role =
      changeset
      |> get_role_assoc(attrs)

    changeset
    |> put_assoc(:role, role)
  end

  def get_assoc(changeset, :department, attrs) do
    department =
      changeset
      |> get_department_assoc(attrs)

    changeset
    |> put_assoc(:department, department)
  end

  def get_unit_assoc(changeset, attrs) do
    case attrs do
      %{:unit => unit} ->
        unit

      %{"unit" => unit} ->
        unit

      _ ->
        case changeset.data do
          %{unit_id: nil} ->
            %{}

          %{unit: unit} ->
            unit
        end
    end
  end

  def get_role_assoc(changeset, attrs) do
    case attrs do
      %{:role => role} ->
        role

      %{"role" => role} ->
        role

      _ ->
        case changeset.data do
          %{role_id: nil} ->
            %{}

          %{role: role} ->
            role
        end
    end
  end

  def get_department_assoc(changeset, attrs) do
    case attrs do
      %{:department => department} ->
        department

      %{"department" => department} ->
        department

      _ ->
        case changeset.data do
          %{department_id: nil} ->
            %{}

          %{department: department} ->
            department
        end
    end
  end

  defp validate_name(changeset) do
    changeset
    |> validate_required([:name])
    |> validate_length(:name, min: 3, max: 160)
  end

  defp validate_username(changeset) do
    changeset
    |> validate_required([:username])
    |> validate_length(:username, min: 3, max: 160)
    |> unique_constraint(:username)
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/,
      message: "must have the @ sign and no spaces"
    )
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, Stick.Repo)
    |> unique_constraint(:email)
  end

  defp validate_password(changeset, opts) do
    have_hashed_password? =
      changeset
      |> get_field(:hashed_password)
      |> is_binary()

    have_password? =
      changeset
      |> get_field(:password)
      |> is_binary()

    if have_hashed_password? and !have_password? do
      changeset
    else
      changeset
      |> validate_required([:password])
      |> validate_length(:password, min: 12, max: 72)
      # |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
      # |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
      # |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
      |> maybe_hash_password(opts)
    end
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      # If using Bcrypt, then further validate it is at most 72 bytes long
      |> validate_length(:password, max: 72, count: :bytes)
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  @doc """
  A user changeset for changing the email.

  It requires the email to change otherwise an error is added.
  """
  def email_changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_email()
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, "did not change")
    end
  end

  @doc """
  A user changeset for changing the password.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def password_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_password(opts)
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(user) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    change(user, confirmed_at: now)
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%Stick.Accounts.User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end
end
