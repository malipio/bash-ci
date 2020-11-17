#!/usr/bin/env bash

function build_gradle_wrapper() {
    sh ./gradlew clean build
}