       A"The Comlogo enterprise MIB for firewall connection information."  "E-mail: zhangml@Comlogo.com.cn"               �"The connection threshhold. Trap messages will be
             sent when the number of connections reaches
             or is beyond this value."                       2"The total connection number at the current time."                       9"The total static connection number at the current time."                       :"The total dynamic connection number at the current time."                          8"Indicate the address set to search. source(1) indicate 
             to only search the source IP addresses of all connections,
             destination(2) to only search the destination addresses, 
             and both(3) to search all the source and destination IP
             addresses of the connections."                       �"Indicate the lower limit of connection number to search,
             that is, to search all the IPs with number of connections
             greater than or equal to this value."                       �"Indicate the upper limit of connection number to search,
             that is, to search all the IPs with number of connections
             less than or equal to this value."                       "The connection type."                       $"Indicate the IP address to search."                       *"A list of connection statistics entries."                       Y"An entry containing connection statistics information
             at the current time."                       4"A unique value, greater than zero, for each entry."                       $"Indicate the IP address to search."                       k"The number of connections with the source IP address as 
             the fwConnIP address in this entry."                       o"The number of connections with the destination IP address
             as the fwConnIP address in this entry."                       N"The check type of the IP address (fwConnIP) as source 
             address."                       Z"The threshold for number of connections with fwConnIP as
             source IP address."                       S"The check type of the IP address (fwConnIP) as destination 
             address."                       _"The threshold for number of connections with fwConnIP as
             destination IP address."                       "The IP type."                       4"The real number of top 10 source connection items."                       f"A list of IP address with which the number of 
             connections as source address is top 10."                       Y"An entry containing connection statistics information
             at the current time."                       4"A unique value, greater than zero, for each entry."                       "the source IP address ."                       M"Number of connections with the source address
             fwConnTopSrcIP ."                       4"The real number of top 10 source connection items."                       f"A list of IP address with which the number of 
             connections as source address is top 10."                       Y"An entry containing connection statistics information
             at the current time."                       4"A unique value, greater than zero, for each entry."                       "The destination IP address ."                       M"Number of connections with the source address
             fwConnTopDesIP ."                       "The number of  connections."                       ,"A table containing connection information."                      0"A conceptual row of the fwConnDetailTable containing information
            about a particular current TCP/UDP connection.  Each row of this
            table is transient, in that it ceases to exist when (or soon
            after) the connection makes the transition to the CLOSED
            state."                       4"A unique value, greater than zero, for each entry."                       �"The source IP address for this TCP/UDP connection.  In the case
            of a connection in the listen state which is willing to
            accept connections for any IP interface associated with the
            node, the value 0.0.0.0 is used."                       9"The destination IP address for this TCP/UDP connection."                       5"The source port number for this TCP/UDP connection."                       :"The destination port number for this TCP/UDP connection."                       +"The protocal for this TCP/UDP connection."                       ("The state for this TCP/UDP connection."                       *"The timeout for this TCP/UDP connection."                                  