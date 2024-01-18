SUBROUTINE BD.SOC.UPDATE.HIGHBAL
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $INSERT I_AA.LOCAL.COMMON
    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    $USING AA.Framework
    $USING EB.SystemTables
*-----------------------------------------------------------------------------
    Y.ACCOUNTNO=''
    Y.TXN.AMT=''
    Y.TXN.REF=''

    Y.ACCOUNTNO = c_aalocLinkedAccount
    Y.RECORD.STATUS = c_aalocActivityStatus
    IF Y.RECORD.STATUS EQ 'AUTH' OR Y.RECORD.STATUS EQ 'AUTH-REV' THEN
        CALL BD.SOC.ANYTIME.HIGHBAL(Y.ACCOUNTNO,Y.RECORD.STATUS)
    END
END
