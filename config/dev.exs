use Mix.Config

config :logger, level: :warn

config :sentinel, Sentinel.Guardian,
  # optional
  allowed_algos: ["HS512"],
  # optional
  verify_module: Guardian.JWT,
  issuer: "Sentinel",
  ttl: {30, :days},
  # optional
  verify_issuer: true,
  secret_key: "guardian_sekret",
  serializer: Sentinel.GuardianSerializer,
  hooks: Guardian.DB,
  permissions: Application.get_env(:sentinel, :permissions)

config :guardian, Guardian.DB, repo: Sentinel.TestRepo

config :sentinel,
  app_name: "Test App",
  user_model: Sentinel.User,
  emailing_module: Sentinel.TestMailing,
  email_sender: "test@example.com",
  crypto_provider: Comeonin.Bcrypt,
  unauthorized_handler: Sentinel.AuthHandler,
  repo: Sentinel.TestRepo,
  environment: :test,
  send_emails: true

config :sentinel, Sentinel.TestRepo,
  username: "postgres",
  password: "postgres",
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox,
  url: "ecto://localhost/sentinel_test",
  size: 1,
  max_overflow: 0

config :sentinel, Sentinel.Mailer,
  adapter: Bamboo.TestAdapter,
  html_email_templates: "lib/sentinel/templates/",
  text_email_templates: "lib/sentinel/templates/"
