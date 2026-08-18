FROM ruby:3.4

# Gems live in the bind-mounted project so they survive between `compose run`
# invocations without a named volume (and its file-ownership headaches).
ENV BUNDLE_PATH=/app/vendor/bundle \
    BUNDLE_APP_CONFIG=/app/.bundle \
    HOME=/tmp

WORKDIR /app

CMD ["bash"]
