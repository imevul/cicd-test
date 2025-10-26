# cicd-test
Testing CI/CD

## Workflow Setup

This repository uses two GitHub Actions workflows:

1. **version-bump.yml** - Automatically bumps the version using git tags and creates a tag when a PR is merged to main. It uses the `anothrNick/github-tag-action@1.67.0` to determine the next version based on the latest git tag, then updates the TOC file to keep it in sync.
2. **release-on-tag.yml** - Automatically creates a GitHub release when a tag is pushed

### Configuration

The version bump workflow can be configured using the following environment variable:

- `TOC_FILE`: Path to the TOC file that should be updated with the new version (default: `src/test.toc`)

You can modify this in the workflow file to point to a different TOC file if your project structure is different.

### Required Secrets

For the `release-on-tag` workflow to be triggered by the `version-bump` workflow, you need to set up a GitHub App with the following permissions:

**GitHub App Permissions:**
- Repository permissions:
  - Contents: Read and write
  - Metadata: Read-only

**Setup Instructions:**

1. Create a GitHub App:
   - Go to Settings → Developer settings → GitHub Apps → New GitHub App
   - Give it a name (e.g., "Version Bump Bot")
   - Disable webhook
   - Set the required permissions (Contents: Read and write)
   - Create the app

2. Install the app on this repository:
   - Go to the app settings → Install App
   - Select this repository

3. Add secrets to the repository:
   - `APP_ID`: The App ID from the GitHub App settings
   - `APP_PRIVATE_KEY`: Generate and download a private key from the GitHub App settings, then add the entire key content as a secret

Once configured, the workflow will use the GitHub App token instead of the default `GITHUB_TOKEN`, which allows the tag push to trigger the `release-on-tag` workflow.
