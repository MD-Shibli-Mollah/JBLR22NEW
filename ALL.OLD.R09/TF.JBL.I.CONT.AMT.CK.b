SUBROUTINE TF.JBL.I.CONT.AMT.CK
*-----------------------------------------------------------------------------
*Attached VERSION    : LETTER.OF.CREDIT,BD.CDOS
*-----------------------------------------------------------------------------
* Modification History : this routine check Document amount exceeds sales contract available Amount.
* 11/29/2020 -                            Create by   - MAHMUDUR RAHMAN (UDOY),
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BD.SCT.CAPTURE
    $USING LC.Contract
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.LocalReferences
    $USING EB.ErrorProcessing
*-----------------------------------------------------------------------------

    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------
*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.SCT='F.BD.SCT.CAPTURE'
    F.SCT=''

    EB.LocalReferences.GetLocRef('LETTER.OF.CREDIT','LT.TF.SCONT.ID',LT.TF.SCONT.ID.POS)
    Y.LC.REF = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
    Y.SCONT.ID = Y.LC.REF<1,LT.TF.SCONT.ID.POS,1>

RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>

    EB.DataAccess.Opf(FN.SCT,F.SCT)
RETURN
*** </region>
 
*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.LC.AMT = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcAmount)
    EB.DataAccess.FRead(FN.SCT,Y.SCONT.ID,REC.SCT,F.SCT,REC.ERR)
    IF REC.SCT THEN
        Y.CONT.AVAIL.AMT = REC.SCT<SCT.CONTRACT.AVAIL.AMT>
        IF Y.LC.AMT GT Y.CONT.AVAIL.AMT THEN
            EB.SystemTables.setAf(LC.Contract.LetterOfCredit.TfLcLcAmount)
            EB.SystemTables.setEtext("Document amount exceeds contract available Amount")
            EB.ErrorProcessing.StoreEndError()
        END
    END
RETURN
*** </region>

END
