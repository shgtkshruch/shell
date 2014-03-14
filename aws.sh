#!/bin/sh
#
# manipulate ec2 instance

# include instance setting

# IMAGE_ID=***
# INSTANCE_TYPE=***
# AVAILABILITY_ZONE=***
# COUNT=***
# SECURITY_GROUP_ID=***
# KEY_NAME=***

source aws_config.sh

get_instance(){
  INSTANCE_DESCRIBES=`aws ec2 describe-instances`

  id_perse(){
    echo ${INSTANCE_DESCRIBES} \
      | jq ".[] | .[] | .Instances | .[] | ${1}" \
      | gsed -e s/\"//g
  }

  INSTANCE_ID=`id_perse ".InstanceId"`
  INSTANCE_STATUS=`id_perse ".State | .Name"`
  PUBLIC_IP=`id_perse ".NetworkInterfaces | .[] | .Association | .PublicIp"`
}

ec2(){
  ec2_instance(){
    aws ec2 "${1}"-instances \
    --instance-ids "${INSTANCE_ID}"
  }

  get_instance

  case "${1}" in
    "info")
      echo "Instanse id: "${INSTANCE_ID}""
      echo "Instanse status: "${INSTANCE_STATUS}""
      echo "Public IP: "${PUBLIC_IP}""
      ;;
    
    "run")
      aws ec2 run-instances \
      --image-id ${IMAGE_ID} \
      --instance-type ${INSTANCE_TYPE} \
      --count ${COUNT} \
      --security-group-ids ${SECURITY_GROUP_ID} \
      --key-name ${KEY_NAME} \
      --placement AvailabilityZone="${AVAILABILITY_ZONE}"
      ;;

    "terminate")
      ec2_instance "terminate"
      ;;

    "start")
      if [ "${INSTANCE_STATUS}" = "stopped" ]; then
        ec2_instance "start"
        gsed -i -e '2d' -e "3i\  Hostname "${PUBLIC_IP}"" ~/.ssh/config
      else
        echo "Instance has been runnning"
      fi
      ;;

    "stop")
      if [ "${INSTANCE_STATUS}" = "running" ]; then
        ec2_instance "stop"
      else
        echo "Instance has been stopped"
      fi
      ;;
  esac
}

ec2 "${1}"
