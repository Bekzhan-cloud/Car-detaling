# GitHub CI

The workflow is defined in `.github/workflows/github-ci.yml`.

## Required repository setup

1. In **Settings -> Pages**, set the source to **GitHub Actions**.
2. Keep the repository default branch as `main`.
3. The workflow uses Node.js 20 and the committed root `package-lock.json`.

Every push to `main` and every pull request runs:

- frontend lint and static build;
- Prisma client generation;
- backend Docker image build;
- Trivy filesystem and image scans;
- CycloneDX SBOM generation;
- SARIF upload to the GitHub Code scanning tab.

A push to `main` deploys `frontend/out` to GitHub Pages only after build and Trivy pass.

## SonarCloud

Create a SonarCloud project for `Raatbek227/Bekjan` and verify the values in
`sonar-project.properties` (`sonar.projectKey` and `sonar.organization`). Then add:

- repository secret `SONAR_TOKEN`;
- repository variable `SONAR_ENABLED=true`.

The Sonar job is skipped until `SONAR_ENABLED` is enabled.

## Fortify on Demand

The workflow uses the current Fortify GitHub Action v3 for Fortify on Demand. Add:

- repository variable `FORTIFY_ENABLED=true`;
- repository variable `FOD_URL`;
- repository secrets `FOD_CLIENT_ID` and `FOD_CLIENT_SECRET`.

The Fortify job is skipped until `FORTIFY_ENABLED` is enabled. Fortify credentials must only be stored as GitHub Actions secrets or variables, never in `.env` files or source code.

## Security policy

Trivy ignores unfixed findings and fails the pipeline on fixed `HIGH` or `CRITICAL`
findings. The generated SBOM is retained as a workflow artifact for 30 days.
