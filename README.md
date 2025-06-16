[![pkg-test](https://github.com/AusSoilsDSM/SLGACloud/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/AusSoilsDSM/SLGACloud/actions/workflows/R-CMD-check.yaml)

# SLGACloud

SLGACloud is an R package to simplify access to the Soil and Landscape Grid of Australia (SLGA) Cloud Optimised GeoTIFF (COG) DataStore URLs directly within R. It provides helper functions for retrieving COG URLs, working with `terra`, and navigating relevant SLGA web resources.

## Installation

```r
# install remotes if needed
install.packages("remotes")

# install SLGACloud from GitHub
remotes::install_github("AusSoilsDSM/SLGACloud")
```

## Usage

```r
library(SLGACloud)

# List available COG URLs
listCOGs()

# Preview package functionality
codeDemo()

# Demonstrate direct COG downloads and plotting
codeDemoCOGs()
```

## Functions

- `listCOGs()`: Retrieve a named list of available SLGA COG URLs.
- `getCOG(name)`: Get the download URL for a specific SLGA layer.
- `plotCOG(name)`: Download and plot a SLGA COG layer using `terra`.
- `codeDemo()`: Run a quick demo of basic package functions.
- `codeDemoCOGs()`: Showcase COG-specific workflows.

## Development Status

> ⚠️ **Alpha** — API and functionality may change. Use with caution in production settings.

## Contributing

Bug reports and feature requests welcome via GitHub issues. Pull requests encouraged.

## License

MIT License. See [LICENSE](LICENSE) for details.

