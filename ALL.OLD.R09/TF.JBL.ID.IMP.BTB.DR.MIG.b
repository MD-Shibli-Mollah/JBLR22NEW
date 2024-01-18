SUBROUTINE TF.JBL.ID.IMP.BTB.DR.MIG
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
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
    F.LC.LEGACY.ID = ''
    FN.DR.LEGACY.ID = 'F.DRAWINGS.LT.DR.LEGACY.ID'
    F.DR.LEGACY.ID = ''
    Y.DR.LEGACY.ID = ''; Y.LC.LEGACY.ID = ''
    Y.DR.LEGACY.ID = EB.SystemTables.getComi()
    Y.LC.LEGACY.ID = Y.DR.LEGACY.ID[1, LEN(Y.DR.LEGACY.ID)-2]
RETURN

**********
OPENFILES:
**********
    EB.DataAccess.Opf(FN.LC.LEGACY.ID, F.LC.LEGACY.ID)
    EB.DataAccess.Opf(FN.DR.LEGACY.ID, F.DR.LEGACY.ID)
RETURN
    
********
PROCESS:
********
    EB.DataAccess.FRead(FN.DR.LEGACY.ID, Y.DR.LEGACY.ID, REC.DR.LEGACY.ID, F.DR.LEGACY.ID, ERR.DR.LEGACY.ID)
    IF REC.DR.LEGACY.ID NE '' THEN
        Y.T24.DR.ID = FIELD(REC.DR.LEGACY.ID,'*',2)
        EB.SystemTables.setComi(Y.T24.DR.ID)
    END ELSE
        EB.DataAccess.FRead(FN.LC.LEGACY.ID, Y.LC.LEGACY.ID, REC.LC.LEGACY.ID, F.LC.LEGACY.ID, ERR.LC.LEGACY.ID)
        IF REC.LC.LEGACY.ID NE '' THEN
            Y.T24.LC.ID = FIELD(REC.LC.LEGACY.ID,'*',2)
            EB.SystemTables.setComi(Y.T24.LC.ID)
        END
    END
RETURN
END