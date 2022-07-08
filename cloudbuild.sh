declare -a ROS_VERSIONS=( "foxy" "galactic" "humble" "rolling" )

ORGANIZATION="microsoft"
declare -a MODEL_VERSIONS=( "swin-tiny-patch4-window7-224", "swin-base-patch4-window7-224", 
"swin-large-patch4-window7-224", "swin-small-patch4-window7-224", "swin-base-patch4-window12-384", "swin-large-patch4-window7-224")

for VERSION in "${ROS_VERSIONS[@]}"
do
  for MODEL_VERSION in "${MODEL_VERSIONS[@]}"
  do
    ROS_VERSION="$VERSION"
    gcloud builds submit --config cloudbuild.yaml . --substitutions=_ROS_VERSION="$ROS_VERSION",_MODEL_VERSION="$MODEL_VERSION",_ORGANIZATION="$ORGANIZATION" --timeout=10000 &
    pids+=($!)
    echo Dispached "$MODEL_VERSION" on ROS "$ROS_VERSION"
  done
done

for pid in ${pids[*]}; do
  wait "$pid"
done

echo "All builds finished"
