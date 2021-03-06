#!/bin/bash

root_dir=$PWD/$(dirname $0)
examples_failed=0

GREEN='\033[0;32m'
RED='\033[0;31m'
NOCOLOR='\033[0m'

DESCRIBE="When on the happy journey"
  IT="makes a cf-deployment vars store from source manifests"
    pushd $(mktemp -d) > /dev/null
      ${root_dir}/../extract-vars-store-from-manifests.sh \
        -cf ${root_dir}/fixture/source-cf-manifest.yml \
        -d  ${root_dir}/fixture/source-diego-manifest.yml \
        -ca ${root_dir}/fixture/ca-private-keys.yml > /dev/null

      diff -wB -C5 ${root_dir}/fixture/expected-vars-store.yml deployment-vars.yml
      status=$?

      if [ "$status" == "0" ]; then
        echo -e ${GREEN} PASS ${NOCOLOR} - ${IT}
      else
        echo -e ${RED} FAIL ${NOCOLOR} - ${IT}
        examples_failed=1
      fi
    popd > /dev/null

  IT="when run without -N, makes a cf-deployment vars store from source manifests that does not include cf-networking vars"
    pushd $(mktemp -d) > /dev/null
      ${root_dir}/../extract-vars-store-from-manifests.sh \
        -cf ${root_dir}/fixture/source-cf-manifest.yml \
        -d  ${root_dir}/fixture/source-diego-manifest.yml \
        -ca ${root_dir}/fixture/ca-private-keys.yml > /dev/null

      diff -wB -C5 ${root_dir}/fixture/expected-vars-store.yml deployment-vars.yml
      status=$?

      if [ "$status" == "0" ]; then
        echo -e ${GREEN} PASS ${NOCOLOR} - ${IT}
      else
        echo -e ${RED} FAIL ${NOCOLOR} - ${IT}
        examples_failed=1
      fi
    popd > /dev/null

  IT="makes a cf-deployment vars store from source manifests with cf-networking enabled"
    pushd $(mktemp -d) > /dev/null
      ${root_dir}/../extract-vars-store-from-manifests.sh \
        -cf ${root_dir}/fixture/source-cf-manifest.yml \
        -d  ${root_dir}/fixture/source-diego-manifest.yml \
        -ca ${root_dir}/fixture/source-ca-private-keys-cf-networking.yml \
        -N > /dev/null

      diff -wB -C5 ${root_dir}/fixture/expected-cf-networking-vars.yml deployment-vars.yml
      status=$?

      if [ "$status" == "0" ]; then
        echo -e ${GREEN} PASS ${NOCOLOR} - ${IT}
      else
        echo -e ${RED} FAIL ${NOCOLOR} - ${IT}
        examples_failed=1
      fi
    popd > /dev/null

  IT="makes a cf-deployment vars store from source manifests without routing_api_client"
    pushd $(mktemp -d) > /dev/null
      ${root_dir}/../extract-vars-store-from-manifests.sh \
        -cf ${root_dir}/fixture/source-cf-manifest-with-routing-without-routing-api-client.yml \
        -d  ${root_dir}/fixture/source-diego-manifest.yml \
        -ca ${root_dir}/fixture/ca-private-keys.yml \
        -r > /dev/null

      diff -wB -C5 ${root_dir}/fixture/expected-routing-vars-without-routing-api-client.yml deployment-vars.yml
      status=$?

      if [ "$status" == "0" ]; then
        echo -e ${GREEN} PASS ${NOCOLOR} - ${IT}
      else
        echo -e ${RED} FAIL ${NOCOLOR} - ${IT}
        examples_failed=1
      fi
    popd > /dev/null

  IT="makes a cf-deployment vars store from source manifests with routing enabled"
    pushd $(mktemp -d) > /dev/null
      ${root_dir}/../extract-vars-store-from-manifests.sh \
        -cf ${root_dir}/fixture/source-cf-manifest-with-routing.yml \
        -d  ${root_dir}/fixture/source-diego-manifest.yml \
        -ca ${root_dir}/fixture/ca-private-keys.yml \
        -r > /dev/null

      diff -wB -C5 ${root_dir}/fixture/expected-routing-vars.yml deployment-vars.yml
      status=$?

      if [ "$status" == "0" ]; then
        echo -e ${GREEN} PASS ${NOCOLOR} - ${IT}
      else
        echo -e ${RED} FAIL ${NOCOLOR} - ${IT}
        examples_failed=1
      fi
    popd > /dev/null

  IT="makes a cf-deployment vars store from source manifests with cf-networking and routing enabled"
    pushd $(mktemp -d) > /dev/null
      ${root_dir}/../extract-vars-store-from-manifests.sh \
        -cf ${root_dir}/fixture/source-cf-manifest-with-routing.yml \
        -d  ${root_dir}/fixture/source-diego-manifest.yml \
        -ca ${root_dir}/fixture/source-ca-private-keys-cf-networking.yml \
        -N \
        -r > /dev/null

      diff -wB -C5 ${root_dir}/fixture/expected-cf-networking-and-routing-vars.yml deployment-vars.yml
      status=$?

      if [ "$status" == "0" ]; then
        echo -e ${GREEN} PASS ${NOCOLOR} - ${IT}
      else
        echo -e ${RED} FAIL ${NOCOLOR} - ${IT}
        examples_failed=1
      fi
    popd > /dev/null

  IT="makes a cf-deployment vars store from source manifests with locket enabled"
    pushd $(mktemp -d) > /dev/null
      ${root_dir}/../extract-vars-store-from-manifests.sh \
        -cf ${root_dir}/fixture/source-cf-manifest.yml \
        -d  ${root_dir}/fixture/source-diego-manifest.yml \
        -ca ${root_dir}/fixture/ca-private-keys.yml \
        -Q > /dev/null

      diff -wB -C5 ${root_dir}/fixture/expected-locket-vars.yml deployment-vars.yml
      status=$?

      if [ "$status" == "0" ]; then
        echo -e ${GREEN} PASS ${NOCOLOR} - ${IT}
      else
        echo -e ${RED} FAIL ${NOCOLOR} - ${IT}
        examples_failed=1
      fi
    popd > /dev/null

if [[ "${examples_failed}" > 0 ]]; then
  echo -e ${DESCRIBE} ${RED} FAILED! ${NOCOLOR}
  exit 1
else
  echo -e ${DESCRIBE} ${GREEN} PASSED! ${NOCOLOR}
  exit 0
fi

