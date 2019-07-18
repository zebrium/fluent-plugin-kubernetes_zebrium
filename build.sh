#!/bin/sh

echo "Build Zebrium Fluentd filter plugin"

PLUGIN_NAME="fluent-plugin-kubernetes_zebrium"

echo "Build gem $PLUGIN_NAME"
gem build $PLUGIN_NAME

echo "DONE"
