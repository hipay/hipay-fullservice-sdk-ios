#!/bin/bash

 ###############################################
 #   DEPLOY APPLICATION BUILD WITH ENVIRONMENT
 #
 #   - "stage"      : Use stage environment
 #   - "production" : Use production environment
 ###############################################
environment="stage"

function deploy_app() {
    if [ "$1" != "" ]; then
      if [ "$1" = "stage" ] || [ "$1" = "production" ];then
        environment=$1
        echo "Build and deploy application for environment $1"

        if [ "$1" = "production" ];then
            export HIPAY_FULLSERVICE_API_USERNAME=$HIPAY_FULLSERVICE_PROD_API_USERNAME
            export HIPAY_FULLSERVICE_API_PASSWORD=$HIPAY_FULLSERVICE_PROD_API_PASSWORD

            sed -it "s/HPFEnvironmentStage/HPFEnvironmentProduction/" Example/HiPayFullservice/HPFAppDelegate.m
        fi

        echo "Get Identifier"
        python deployment/get_identifier.py $environment > $CIRCLE_ARTIFACTS/app_identifier

        rm Example/HiPayFullservice/Resources/Parameters/parameters.plist

        echo "Set Build number"
        (cd deployment/; python set_build_number.py)

        echo "Generate Parameters"
        (export HOCKEY_APP_IDENTIFIER=$(cat $CIRCLE_ARTIFACTS/app_identifier); cd deployment/; python generate_parameters.py)

        echo "Gym Legacy build"
        gym --use_legacy_build_api

        echo "IPA Distribute"
        ipa distribute:hockeyapp --token "$HOCKEY_APP_TOKEN" --notes "CircleCI build $CIRCLE_BUILD_NUM" --commit-sha "$CIRCLE_SHA1" --build-server-url "$CIRCLE_BUILD_URL" --repository-url "$CIRCLE_REPOSITORY_URL" --identifier "$(cat $CIRCLE_ARTIFACTS/app_identifier)"
    fi
   fi
 }


###############################################
#            DEPLOY VERSION STAGE
###############################################
deploy_app "stage"

###############################################
#            DEPLOY VERSION PRODUCTON
###############################################
if [ "$CIRCLE_BRANCH" = "master" ];then
    echo "Branch is master, deploy app with production"
    deploy_app "production"
fi


