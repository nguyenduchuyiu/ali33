FROM cirrusci/flutter:latest
WORKDIR /app
COPY . /app/.
RUN flutter pub get
RUN flutter build web --web-renderer html
EXPOSE 80
CMD ["python", "-m", "http.server", "80", "--directory", "build/web"]