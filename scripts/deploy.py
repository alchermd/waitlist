import json
import subprocess

def populate_frontend_vars():
    with open("../terraform-output.json", "r") as output_file:
        output = json.load(output_file)

    with open("../src/js/vars.js", "w") as vars_file:
        api_url = output["form_handler_url"]["value"]
        print(f"Setting apiURL to {api_url}")
        vars_file.write(f'const apiURL = "{api_url}"')

def sync_to_s3():
    "aws s3 sync ./src s3://lootpups-lp"
    with open("../terraform-output.json", "r") as output_file:
        output = json.load(output_file)
        bucket_name = output["website_bucket_name"]["value"]

    cmd = ["aws", "s3", "sync", "../src", f"s3://{bucket_name}"]
    print("Running command: ", " ".join(cmd) )
    subprocess.run(cmd)

def main():
    populate_frontend_vars()
    sync_to_s3()


if __name__ == "__main__":
    main()
