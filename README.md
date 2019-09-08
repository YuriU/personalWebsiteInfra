# personalWebsiteInfra
AWS infrastructure for personal website
Including static website hosting Route53 setting and code pipeline

The main idea was to make reusable AWS infrastructure able to launch static website
During working on the script I faced the issue with SSL certificates validation which requires manual processing

After certificate is issued, the ownership of the domain it was issued for must be validated either by 
email see (https://docs.aws.amazon.com/en_us/acm/latest/userguide/gs-acm-validate-email.html) or by DNS (https://docs.aws.amazon.com/en_us/acm/latest/userguide/gs-acm-validate-dns.html) method

Because of GDPR most registrars dont display email addressed via WHOIS, so the best way to validate certificate is DNS method, which requires configured NSes on the registrar side, which means zone must be created on AWS

Because I did not find any way to brake terraform setup into several apply stages. I decided to split up the infra myself on several stages

1. Create Website bucket & Code pipeline
2. Create hosted zone + print NSs to setup
Here NSs must be set to your domain registrar before you proceed
3. Issuing SSL certificate and waiting till the validation succeed
4. Setup the rest of the site components CDN, DNS records

Maybe it is not the best brake down for the systems where hosted zones and certificates are already set up, but for small websites it can be the most conveniant way



terraform init -backend-config="..\backend_config.tfvars"

terraform apply -var-file="..\terraform.tfvars"