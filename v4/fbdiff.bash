#!/bin/bash
sed -e 's/[0-9]//g' <$1 | sort >temp1
sed -e 's/[0-9]//g' <$2 | sort >temp2
diff temp1 temp2
