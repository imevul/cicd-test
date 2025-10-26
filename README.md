# cicd-test
Testing CI/CD

## Workflow Setup

This repository uses two GitHub Actions workflows with Release Drafter integration for intelligent version bumping:

1. **version-bump.yml** - Automatically bumps the version based on PR labels and branch names when a PR is merged to main. It determines the version bump type (major/minor/patch), updates the TOC file with the new version, commits the change, and creates a tag on that commit. This ensures that checking out a tag will have the correct version in the TOC file.
2. **release-on-tag.yml** - Automatically creates a GitHub release with categorized release notes when a tag is pushed

### Version Bumping Strategy

The version bump is determined using the following priority order:

1. **PR Labels** (highest priority):
   - `major`, `breaking`, or `breaking-change` → Major version bump (e.g., 1.0.0 → 2.0.0)
   - `minor`, `feature`, or `enhancement` → Minor version bump (e.g., 1.0.0 → 1.1.0)
   - `patch`, `fix`, `bugfix`, `bug`, `chore`, `maintenance`, `documentation`, or `docs` → Patch version bump (e.g., 1.0.0 → 1.0.1)

2. **Branch Name Keywords** (fallback if no matching labels):
   - Branch names containing `major` or `breaking` → Major version bump
   - Branch names containing `minor`, `feature`, or `feat` → Minor version bump
   - All other cases → Patch version bump (default)

### Release Notes Categorization

Release Drafter automatically categorizes PRs in the release notes based on labels:

- 🚀 **Features**: `feature`, `enhancement`
- 🐛 **Bug Fixes**: `fix`, `bugfix`, `bug`
- 🧰 **Maintenance**: `chore`, `maintenance`
- 📝 **Documentation**: `documentation`, `docs`
- ⚠️ **Breaking Changes**: `breaking`, `breaking-change`

### Configuration

The version bump workflow can be configured using the following environment variable:

- `TOC_FILE`: Path to the TOC file that should be updated with the new version (default: `src/test.toc`)

You can modify the Release Drafter configuration in `.github/release-drafter.yml` to customize:
- Version bump rules
- Release note categories
- Change log templates

### Usage Examples

**Example 1: Creating a minor version bump**
1. Create a PR from a branch (e.g., `feature/new-functionality`)
2. Add the `feature` or `minor` label to the PR
3. Merge the PR to main
4. The workflow will bump from 1.0.5 → 1.1.0

**Example 2: Creating a major version bump**
1. Create a PR from a branch (e.g., `breaking/api-changes`)
2. Add the `breaking` or `major` label to the PR
3. Merge the PR to main
4. The workflow will bump from 1.1.0 → 2.0.0

**Example 3: Using branch name for version bump (no labels)**
1. Create a PR from a branch named `feature/add-login`
2. Don't add any labels
3. Merge the PR to main
4. The workflow will detect "feature" in the branch name and bump from 2.0.0 → 2.1.0

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
