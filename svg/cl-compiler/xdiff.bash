#!/bin/bash
sort BUILD_PROCESS.json | sed -e 's/[0-9]//g' >temp1
sort hold.json | sed -e 's/[0-9]//g' >temp2
diff temp1 temp2
