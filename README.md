# Waitlist

A very barebones waitlist site that can be spun up in AWS in a minute.

## Local Development

The frontend can be run via: `make up`

## Deployment

Requirements:

- An existing Route53 hosted zone.
- Values for the following (see [.tfvars.example](./terraform/.tfvars.example)):

```terraform
domain_name = "waitlist.example.com"
route53_zone_name = "example.com"
route53_a_record = "waitlist"
route53_zone_id = "ABC123"
```

```console
$ export AWS_PROFILE=my-aws-profile # Or any other way that the current environment has AWS credentials.
$ cp ./terraform/.tfvars.example ./terraform/.tfvars # update the values as needed.
$ make deploy 
```

## Notes

The terraform module assumes that the site will be deployed in a subdomain. If it needs to be on the apex, a handful of changes must be made (but shouldn't be too difficult).

## License

See [LICENSE](./LICENSE)
