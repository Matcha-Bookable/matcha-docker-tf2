# Matcha TF2 Dockerfile

This repository contains the source file of Matcha Bookable's Dockerfile and their build scripts. Sensitive items will be pulled during runtime to ensure security.
This image will be pulled by the on-demand instances from Matcha Bookable's Competitive service. 

### Supported Registries
> I have originally planned to push to all major cloud computing providers' private registries. However, the costs incurred are currently not worth the compensation of simply faster pull time.

- [x] Docker Hub: Public Repository
- [x] Github Container Registry

## Additional Notes

> PAT and API Key from Matcha are required to properly run this image.

### Credits

- [spiretf/docker-tf2-server](https://codeberg.org/spire/docker-tf2-server)
- [spiretf/docker-comp-server](https://codeberg.org/spire/docker-comp-server)

### License
This project is licensed under the GNU GPLv3 License - see the [LICENSE](LICENSE) file for details.