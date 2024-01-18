SUBROUTINE TF.JBL.I.INWARD.FREE.ERA
*PROGRAM TF.JBL.I.INWARD.FREE.ERA
*-----------------------------------------------------------------------------
* VERSION: FUNDS.TRANSFER,JBL.INW.MESS & EB.FREE.MESSAGE,JBL.INW.MESS
*-----------------------------------------------------------------------------
* Modification History : this routine work for truncate the 'XXX' test from filed value if
*                        they have the specipic formate & rewrite the value with wanted formate.
*-----------------------------------------------------------------------------
* 03/28/2021 -                            Created   - Mahmudur Rahman Udoy,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
     
    $USING EB.DataAccess
    $USING EB.SystemTables

    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
    
RETURN
 
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.RECV.ADDR = ''
    Y.RECV.ADDR = EB.SystemTables.getComi()
    Y.RECV.ADDR.PERFIX = Y.RECV.ADDR[1,3]
    
    IF Y.RECV.ADDR.PERFIX EQ 'SW-' THEN
        Y.RECV.ADDR.LAST = Y.RECV.ADDR[12,3]
        IF Y.RECV.ADDR.LAST EQ 'XXX' THEN
            Y.RECV.ADDR.ASIN = Y.RECV.ADDR[1,11]
            EB.SystemTables.setComi(Y.RECV.ADDR.ASIN)
        END
    END ELSE
        Y.RECV.ADDR.LAST = Y.RECV.ADDR[9,3]
        IF Y.RECV.ADDR.LAST EQ 'XXX' THEN
            Y.RECV.ADDR.ASIN = "SW-":Y.RECV.ADDR[1,8]
            EB.SystemTables.setComi(Y.RECV.ADDR.ASIN)
        END
    END
    
*** </region>
RETURN

 
END
