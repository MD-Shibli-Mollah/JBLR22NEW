SUBROUTINE TF.JBL.ID.ELC.OUTCOLL.DR.MIG
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
*-----------------------------------------------------------------------------
* TODO Add logic to validate the id
* TODO Create an EB.ERROR record if you are creating a new error code
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING LC.Contract
    $USING EB.Updates
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

*****
INIT:
*****
    FN.LC.LEGACY.ID = 'F.LETTER.OF.CREDIT.LT.LEGACY.ID'
    F.LEGACY.ID = ''
    Y.DR.LEGACY.ID = ''; Y.LC.LEGACY.ID = ''
    Y.DR.LEGACY.ID = EB.SystemTables.getComi()
    Y.LC.LEGACY.ID = Y.DR.LEGACY.ID[1, LEN(Y.DR.LEGACY.ID)-2]
    Y.COMPANY.LC.ID = ''; Y.LC.ID = ''; REC.LC.LEGACY.ID = ''; REC.LC.LEGACY.ID1 = ''
RETURN

**********
OPENFILES:
**********
    EB.DataAccess.Opf(FN.LC.LEGACY.ID, F.LC.LEGACY.ID)
RETURN
    
********
PROCESS:
********
    EB.DataAccess.FRead(FN.LC.LEGACY.ID, Y.LC.LEGACY.ID, REC.LC.LEGACY.ID, F.LC.LEGACY.ID, ERR.LC.LEGACY.ID)
    EB.DataAccess.FRead(FN.LC.LEGACY.ID, Y.DR.LEGACY.ID, REC.LC.LEGACY.ID1, F.LC.LEGACY.ID, ERR.LC.LEGACY.ID1)

    IF REC.LC.LEGACY.ID NE '' THEN
        Y.COMPANY.LC.ID = REC.LC.LEGACY.ID
    END ELSE
        IF REC.LC.LEGACY.ID1 NE '' THEN
            Y.COMPANY.LC.ID = REC.LC.LEGACY.ID1
        END
    END
    Y.LC.ID = FIELD(Y.COMPANY.LC.ID,'*',2)
    EB.SystemTables.setComi(Y.LC.ID)
RETURN
END