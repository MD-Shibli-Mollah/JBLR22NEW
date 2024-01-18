SUBROUTINE TF.JBL.ID.FDBC.AGN.CONT
*-----------------------------------------------------------------------------
* Modification History :
* 12/15/2020 -                            Retrofit   - MAHMUDUR RAHMAN UDOY,
*                                                 FDS Bangladesh Limited
* Need Attach to this version: DRAWINGS,BD.OUTCOLL
* This routine restrict user to open mutipule Drawings.
* it's temporary removed from this version for bank testing purpose.
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

    $USING EB.DataAccess
    $USING LC.Contract
    $USING EB.SystemTables
    $USING EB.ErrorProcessing


*-----------------------------------------------------------------------------
    Y.FUNCTION = EB.SystemTables.getVFunction()
    IF Y.FUNCTION EQ 'I' THEN
        GOSUB INIT
        GOSUB OPENFILES
        GOSUB PROCESS
    END
RETURN

*****
INIT:
*****
    FN.LC = 'F.LETTER.OF.CREDIT'
    F.LC = ''

    Y.DR.ID = EB.SystemTables.getComi()
    Y.LC.ID = Y.DR.ID[1,12]
RETURN

***********
OPENFILES:
***********
    EB.DataAccess.Opf(FN.LC,F.LC)
RETURN

********
PROCESS:
********

    EB.DataAccess.FRead(FN.LC,Y.LC.ID,R.LC.REC,F.LC,LC.ERR)
    IF R.LC.REC THEN
        Y.DR.COUNT = R.LC.REC<LC.Contract.LetterOfCredit.TfLcNextDrawing>
        IF Y.DR.COUNT GE 2 THEN
            EB.SystemTables.setE("More than one Drawings not allowed agt Reg Doc")
            EB.ErrorProcessing.StoreEndError()
        END
    END
RETURN

END
