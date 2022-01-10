FROM elixir:1.13

WORKDIR /app

RUN apt-get update && apt-get install -y inotify-tools

RUN mix local.hex --force && mix local.rebar --force

COPY mix.exs /app
COPY mix.lock /app
RUN mix do deps.get, deps.compile

COPY . /app
RUN mix compile

EXPOSE 4000

CMD ["mix", "phx.server"]
