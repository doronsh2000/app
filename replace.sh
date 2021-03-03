aws_new_env=`curl http://169.254.169.254/latest/meta-data/identity-credentials/ec2/info   | grep -i "968741681021" | awk '{print $3}'
|  sed s/\"//g `
instance_id=`curl http://169.254.169.254/latest/meta-data/instance-id`


echo $aws_new_env
if [[ $aws_new_env == "968741681021" ]] ; then
   echo "true - new environment"
   echo `pwd`
   install_dir=`cat /opt/codedeploy-agent/deployment-root/deployment-instructions/*_most_recent_install`

   instance_tags=`aws ec2 describe-tags --filters Name=key,Values=Name Name=resource-id,Values=${instance_id}  --region eu-west-2 | jq
 .Tags[0].Value  |  sed s/\"//g`

   echo $instance_tags
   if [[ $instance_tags == "QA-VFAppmarket-Service" ]]; then
       echo "it's qa"
       sed -i 's/post_install/post_install_for_marketplace_qa/' ${install_dir}/deployment-archive/appspec.yml
       sed -i 's/start_container/start_container_for_marketplace_qa/' ${install_dir}/deployment-archive/appspec.yml
       /usr/bin/systemctl restart docker

   elif [[ $instance_tags == "Dev-VFAppmarket-Service" ]]; then
       echo "it's dev"
       sed -i 's/post_install/post_install_for_marketplace_dev/' ${install_dir}/deployment-archive/appspec.yml
       sed -i 's/start_container/start_container_for_marketplace_dev/' ${install_dir}/deployment-archive/appspec.yml
       /usr/bin/systemctl restart docker

   elif [[ $instance_tags == "CST-VFAppmarket-Service" ]]; then
       echo "it's cst"
       sed -i 's/post_install/post_install_for_marketplace_cst/' ${install_dir}/deployment-archive/appspec.yml
       sed -i 's/start_container/start_container_for_marketplace_cst/' ${install_dir}/deployment-archive/appspec.yml
       /usr/bin/systemctl restart docker

   else
      echo "false - old environemnt"
   fi
fi


#### add code for MKTP Prod

aws_new_env=`curl http://169.254.169.254/latest/meta-data/identity-credentials/ec2/info   | grep -i "596384114749" | awk '{print $3}'|
  sed s/\"//g `
instance_id=`curl http://169.254.169.254/latest/meta-data/instance-id`


blabla
blabla2

echo $aws_new_env
if [[ $aws_new_env == "596384114749" ]] ; then
   echo "true - new environment"
   echo `pwd`
   install_dir=`cat /opt/codedeploy-agent/deployment-root/deployment-instructions/*_most_recent_install`

   instance_tags=`aws ec2 describe-tags --filters Name=key,Values=Name Name=resource-id,Values=${instance_id}  --region ap-southeast-2
 | jq .Tags[0].Value  |  sed s/\"//g`

   echo $instance_tags
   if [[ $instance_tags == "Prod-VFAppmarket-Service" ]]; then
       echo "it's prod"
       sed -i 's/post_install/post_install_for_marketplace_prod/' ${install_dir}/deployment-archive/appspec.yml
       sed -i 's/start_container/start_container_for_marketplace_prod/' ${install_dir}/deployment-archive/appspec.yml
       /usr/bin/systemctl restart docker


   else
      echo "false - old environemnt"
   fi
fi

