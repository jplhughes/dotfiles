#!/usr/bin/env python

import xml.dom.minidom
import os
from datetime import datetime
import timeago

titanx_list = ["code0", "code11", "code20", "code5"]
gpu980_list = ["code10", "code12", "code13", "code15", "code16"]

def fakeqstat(joblist):
    print("JOB ID", '\t', "USER".ljust(8), '\t', "NAME".ljust(16), '\t', "STATE", '\t', "MACHINE".ljust(8), '\t', "TIME AGO".ljust(16))
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

            print(job_ID, '\t', user.ljust(8), '\t', name.ljust(16), '\t', state, '\t', queue_info.ljust(8), '\t', time_ago.ljust(16))
        except Exception as e:
            print(e)

qstat_output = os.popen('qstat -u \* -xml -r')
qstat_xml = xml.dom.minidom.parse(qstat_output)
job_info = qstat_xml.getElementsByTagName('job_info')[0]
job_list = job_info.getElementsByTagName('job_list')
fakeqstat(job_list)