# Deployment Notes

This Rails app includes a generated `Dockerfile` and Kamal configuration scaffold. For a real hosted deployment, configure production credentials, provision a host, set the image name and server target in `config/deploy.yml`, then run the normal Kamal deploy flow.

For local assessment review:

```bash
bin/rails db:prepare
bin/rails db:seed
bin/rails server
```

The dashboard is available at `http://localhost:3000`.
