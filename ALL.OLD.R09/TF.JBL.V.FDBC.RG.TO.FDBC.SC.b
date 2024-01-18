SUBROUTINE TF.JBL.V.FDBC.RG.TO.FDBC.SC
*-----------------------------------------------------------------------------
*Subroutine Description: Update Tenor Days Field Value from DR to LC
*Subroutine Type:
*Attached To    : LETTER.OF.CREDIT Versions for charge - 
*Attached As    : VALIDATION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 10/28/2020 -                            Retrofit   - SHAJJAD HOSSEN ANIK,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.OverrideProcessing
    $USING LC.Contract
    $USING EB.Updates
    $USING EB.TransactionControl
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
INIT:
    Y.DR.ID = EB.SystemTables.getComi()
    Y.LC.ID = Y.DR.ID[1,12]
    
    FN.LC = 'F.LETTER.OF.CREDIT'
    F.LC = ''
    FN.DR = 'DRAWINGS'
    F.DR = ''

    FLD.POS = ''
    APPLICATION.NAME = 'LETTER.OF.CREDIT':FM:'DRAWINGS'
    LOCAL.FIELD = 'LT.TF.LC.TENOR':FM:'LT.TF.LC.TENOR'
    EB.Updates.MultiGetLocRef(APPLICATION.NAME,LOCAL.FIELD,FLD.POS)
    Y.TENOR.POS = FLD.POS<1,1>
    Y.TENOR.DR.POS = FLD.POS<2.1>
RETURN

OPENFILES:
***********
    EB.DataAccess.Opf(FN.DR,F.DR)
    EB.DataAccess.Opf(FN.LC,F.LC)
RETURN

PROCESS:
*******
    EB.DataAccess.FRead(FN.LC,Y.LC.ID,R.LC,F.LC,LC.REG)
    Y.TENOR.LC = R.LC<LC.Contract.LetterOfCredit.TfLcLocalRef><1,Y.TENOR.POS>
    
    Y.TEMP = EB.SystemTables.getRNew(MD.Contract.Deal.DeaLocalRef)
    Y.TEMP<1,Y.TENOR.DR.POS> = Y.TENOR.LC

    EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrLocalRef, Y.TEMP)
RETURN
END
