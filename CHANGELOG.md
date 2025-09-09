# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

### Added

### Changed

### Removed

## [1.1.0] - 2025-09-08

### Added

- Get-TDXTicketAttachmentContent: Download an attachment from a ticket

## [1.0.1] - 2025-01-27

### Changed

- Add-TDXTicketAttachment: Changes to API were corrupting Excel files on upload. This change addresses that issue.
- README.md: Update guidance on using the environment variable.
- UofITDXTickets.psm1: Remove import from settings.json as it just gets overwritten by the environment variable and causes confusion.

### Removed

- Settings.json: moved example in this file to the README.md for clarity.

## [1.0.0] - 2024-10-24

### Changed

- Change module version number to 1.0.0 for release
- Change module name in PublishToGallery Action
- Change module name in CONTRIBUTING.md

### Added

- Icon added for PowerShell Gallery


## [0.0.1] - 2024-10-21

### Added

- Module initialization, submitted for review prior to release
