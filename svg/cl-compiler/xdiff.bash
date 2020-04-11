#!/bin/bash
sed -e 's/[0-9]//g' <IDE.ir | sort >temp1
sed -e 's/[0-9]//g' <hold.ir | sort >temp2
diff temp1 temp2
