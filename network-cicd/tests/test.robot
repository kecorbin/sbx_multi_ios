# Demo Script to verify sanity of network

*** Settings ***
# Importing test libraries, resource files and variable files.
Library        genie.libs.robot.GenieRobot

# we can also import variables from yaml
# Variables      prod_vars.yaml

*** Variables ***
# Defining variables that can be used elsewhere in the test data.
# Can also be driven as dash argument at runtime

# Define the pyATS testbed file to use for this run
${testbed}      ./test_testbed.yml

# Genie Libraries to use
${trigger_datafile}     /pyats/genie_yamls/iosxe/trigger_datafile_iosxe.yaml
${verification_datafile}     /pyats/genie_yamls/iosxe/verification_datafile_iosxe.yaml

*** Test Cases ***
# Creating test cases from available keywords.

Initialize
    # Initializes the pyATS/Genie Testbed
    # pyATS Testbed can be used within pyATS/Genie
    use genie testbed "${testbed}"
    execute testcase    reachability.pyats_loopback_reachability.common_setup

Ping
    execute testcase     reachability.pyats_loopback_reachability.PingTestcase    device=test-core1
    execute testcase     reachability.pyats_loopback_reachability.PingTestcase    device=test-core2
    execute testcase     reachability.pyats_loopback_reachability.NxosPingTestcase    device=test-dist1
    execute testcase     reachability.pyats_loopback_reachability.NxosPingTestcase    device=test-dist2



# Verify OSPF neighbor counts
Verify Ospf neighbors test-dist1
    verify count "2" "ospf neighbors" on device "test-dist1"
Verify Ospf neighbors test-dist2
    verify count "2" "ospf neighbors" on device "test-dist2"
Verify Ospf neighbors test-core1
    verify count "2" "ospf neighbors" on device "test-core1"
Verify Ospf neighbors test-core2
    verify count "2" "ospf neighbors" on device "test-core1"


# Verify Interfaces
Verify Interface test-dist1
    verify count "74" "interface up" on device "test-dist1"
Verify Interface test-dist2
    verify count "76" "interface up" on device "test-dist2"
Verify Interface test-core1
    verify count "12" "interface up" on device "test-core1"
Verify Interface test-core2
    verify count "10" "interface up" on device "test-core2"

Terminate
    execute testcase "reachability.pyats_loopback_reachability.common_cleanup"
