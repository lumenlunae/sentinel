use Mix.Config

config :logger, level: :warn

config :sentinel, Sentinel.Endpoint,
  secret_key_base: "DOInS/rFmVWzmcHaoYAXX8moniIGldPCvtGcYv+GY5XE5xS8aQKRH4Aw6gDUmncd"

config :sentinel, Sentinel.TestRepo,
  username: "postgres",
  password: "postgres",
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox,
  url: "ecto://localhost/sentinel_test",
  size: 1,
  max_overflow: 0,
  priv: "test/support"

config :sentinel, Sentinel.Guardian,
  issuer: "Sentinel",
  secret_key: "guardian_sekret",
  # optional
  allowed_algos: ["HS512"],
  # optional
  verify_module: Guardian.JWT,
  ttl: {30, :days},
  # optional
  verify_issuer: true,
  serializer: Sentinel.GuardianSerializer,
  # optional - only needed if using guardian db
  hooks: Guardian.DB,
  permissions: %{}

# Only relevant to test ^^

config :sentinel,
  app_name: "Test App",
  # FIXME should be your generated model
  user_model: Sentinel.User,
  send_address: "test@example.com",
  crypto_provider: Comeonin.Bcrypt,
  # FIXME should be your repo
  repo: Sentinel.TestRepo,
  ecto_repos: [Sentinel.TestRepo],
  auth_handler: Sentinel.AuthHandler,
  views: %{
    # your email view (optional)
    email: Sentinel.EmailView,
    # your error view (optional)
    error: Sentinel.ErrorView,
    # your password view (optional)
    password: Sentinel.PasswordView,
    # your session view (optional)
    session: Sentinel.SessionView,
    # your shared view (optional)
    shared: Sentinel.SharedView,
    # your user view (optional)
    user: Sentinel.UserView
  },
  # FIXME your router
  router: Sentinel.TestRouter,
  # FIXME your endpoint
  endpoint: Sentinel.Endpoint,
  invitable: true,
  # for api usage only
  invitation_registration_url: "http://localhost:4000",
  confirmable: :optional,
  # for api usage only
  confirmable_redirect_url: "http://localhost:4000",
  # for api usage only
  password_reset_url: "http://localhost:4000",
  send_emails: true,
  permissions: %{}

config :guardian, Guardian.DB,
  # FIXME your repo
  repo: Sentinel.TestRepo

config :sentinel, Sentinel.Mailer, adapter: Bamboo.TestAdapter

config :ueberauth, Ueberauth,
  providers: [
    identity: {
      Ueberauth.Strategy.Identity,
      [
        param_nesting: "user",
        callback_methods: ["POST"]
      ]
    },
    github: {
      Ueberauth.Strategy.Github,
      []
    }
  ]
