#!/usr/bin/env python

import xml.dom.minidom
import os
from datetime import datetime
import timeago
from tabulate import tabulate

titanx_list = ["code0", "code11", "code20", "code5"]
gpu980_list = ["code10", "code12", "code13", "code15", "code16"]

def fakeqstat(joblist):
    table = []
    for job in joblist:
        try:
            # extract information from qstat output
            job_ID = job.getElementsByTagName('JB_job_number')[0].childNodes[0].data
            name = job.getElementsByTagName('JB_name')[0].childNodes[0].data
            user = job.getElementsByTagName('JB_owner')[0].childNodes[0].data
            state = job.getElementsByTagName('state')[0].childNodes[0].data
            if state == 'r' or state == 'dt':
                start_time = job.getElementsByTagName('JAT_start_time')[0].childNodes[0].data
            else:
                start_time = job.getElementsByTagName('JB_submission_time')[0].childNodes[0].data
            queue = job.getElementsByTagName('queue_name')[0].childNodes # sometimes empty so don't index
            hard_req_queue = job.getElementsByTagName('hard_req_queue')[0].childNodes[0].data
            processing_unit = hard_req_queue.split(".")[0]

            # extract machine info
            machine = None
            if queue:
                queue = queue[0].data
                machine = queue.split("@")[1].split(".")[0]
            queue_info = f"{processing_unit}@{machine}"

            # datetimes and time ago
            now_datetime = datetime.now()
            start_datetime = datetime.strptime(start_time, '%Y-%m-%dT%H:%M:%S')
            time_ago = timeago.format(start_datetime, now_datetime)

            table.append([job_ID, user, name, state, queue_info, time_ago])
        except Exception as e:
            print(e) 
    return table

servers = ["codex", "bastion"]
full_table = []
for server in servers:
    # Get qstat information
    qstat_cmd = "qstat -u \* -xml -r"
    if server == "bastion":
        qstat_cmd = "ssh -t johnh@192.168.6.231 '%s' 2> /dev/null" % qstat_cmd
    qstat_output = os.popen(qstat_cmd)
    qstat_xml = xml.dom.minidom.parse(qstat_output)
    job_info = qstat_xml.getElementsByTagName('job_info')[0]
    job_list = job_info.getElementsByTagName('job_list')
    table = fakeqstat(job_list)
    full_table.extend(table)

headers = ["JOB ID", "USER", "NAME", "STATE", "MACHINE", "SUBMITTED"]
print(tabulate(full_table, headers, tablefmt="presto"))