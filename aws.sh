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

source $HOME/bin/aws_config.sh

get_instance(){
  DESCRIBE_INSTANCE=`aws ec2 describe-instances`

  instance_perse(){
    echo ${DESCRIBE_INSTANCE} \
      | jq ".[] | .[] | .Instances | .[] | ${1}" \
      | gsed -e s/\"//g
  }

  INSTANCE_ID=`instance_perse ".InstanceId"`
  INSTANCE_STATUS=`instance_perse ".State | .Name"`
  PUBLIC_IP=`instance_perse ".NetworkInterfaces | .[] | .Association | .PublicIp"`
  INSTANCE_TYPE=`instance_perse ".InstanceType"`
  LAUNCHTIME=`instance_perse ".LaunchTime"`
}

get_volume(){
  DESCRIBE_VOLUMES=`aws ec2 describe-volumes`
  
  volume_perse(){
    echo ${DESCRIBE_VOLUMES} \
      | jq ".Volumes | .[] | ${1}" \
      | gsed -e s/\"//g
  }
  VOLUME_TYPE=`volume_perse ".VolumeType"`
  SIZE=`volume_perse ".Size"`
  CREATE_TIME=`volume_perse ".CreateTime"`
}

ec2(){
  ec2_instance(){
    aws ec2 "${1}"-instances \
    --instance-ids "${INSTANCE_ID}"
  }

  get_instance
  get_volume

  case "${1}" in
    "status")
      echo "********** Insance **********"
      echo "id: "${INSTANCE_ID}""
      echo "type:" "${INSTANCE_TYPE}"
      echo "status: "${INSTANCE_STATUS}""
      echo "Public IP: "${PUBLIC_IP}""
      echo "Launch time: "${LAUNCHTIME}""
      echo "********** Volume **********"
      echo "type: "${VOLUME_TYPE}""
      echo "Size: "${SIZE}"GB"
      echo "Create time: "${CREATE_TIME}""
      ;;
    
    "create")
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

    *)
      echo "error"
      ;;

  esac
}

ec2 "${1}"
