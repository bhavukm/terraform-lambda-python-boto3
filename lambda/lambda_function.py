import os,boto3
ec2=boto3.client("ec2")
def lambda_handler(event,context):
    ids=os.environ["INSTANCE_IDS"].split(",")
    action=event.get("action")
    if action=="start":
        ec2.start_instances(InstanceIds=ids)
    elif action=="stop":
        ec2.stop_instances(InstanceIds=ids)
    return {"status":"ok","action":action,"instances":ids}
