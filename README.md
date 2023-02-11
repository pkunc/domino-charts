# Helm Chart for HCL Domino
A Helm chart for HCL Domino server. Unofficial.

## Overview

This [Helm](https://helm.sh/) chart installs [HCL Domino](https://www.hcltechsw.com/domino) V12 in a [Kubernetes](https://kubernetes.io/) cluster.

The chart is unofficial; I created it for my usage when deploying Domino in containers.


## Installation

Read the instructions in the chart [README](charts/domino/README.md) file.


## Author
Petr Kunc


## Credits

I was initially inspired by the work of [Daniel Nashed](https://github.com/Daniel-Nashed) and [Thomas Hampel](https://github.com/thampel).

The Helm chart uses a Domino container created by [_domino-container_](https://github.com/HCL-TECH-SOFTWARE/domino-container) community build script, maintained by Daniel Nashed.

The original _One-touch Setup_ YAML config file was created by Daniel Nashed.


## License

This project is licensed under [Apache 2.0 license](/LICENSE).


## Disclaimer

This product is not officially supported and can be used as-is. This product is only a proof of concept, and the author would welcome any feedback. The author does not make any warranty about the completeness, reliability, and accuracy of this code. Any action you take by using this code is strictly at your own risk, and the author will not be liable for any losses and damages in connection with the use of this code.