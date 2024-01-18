SUBROUTINE TF.JBL.V.SALES.CON.REP
*-----------------------------------------------------------------------------
*VERSION: LETTER.OF.CREDIT,BD.ELC.REPLACE
*DESCRIPTION: get buyer id & buyer details write them to Contact Rep LC Application details.
*-----------------------------------------------------------------------------
* Modification History :                      Created by: Mahmudur Rahman
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BD.SCT.CAPTURE
    $USING LC.Contract
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.LocalReferences
*-----------------------------------------------------------------------------

    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
*-----------------------------------------------------------------------------
*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.LC='F.LETTER.OF.CREDIT'
    F.LC=''

    FN.SCT='F.BD.SCT.CAPTURE'
    F.SCT=''
   
    Y.SCONT.ID = EB.SystemTables.getComi()
    Y.APP.ID = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcApplicantCustno)
    
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.LC,F.LC)
    EB.DataAccess.Opf(FN.SCT,F.SCT)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    
    EB.DataAccess.FRead(FN.SCT,Y.SCONT.ID,REC.SCT,F.SCT,REC.ERR)
    IF REC.SCT THEN
        Y.BUYER.ID   = REC.SCT<SCT.APPLICANT.CUSTNO>
        IF Y.APP.ID EQ '' THEN
            EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcApplicantCustno,Y.BUYER.ID)
        END
    END
RETURN
*** </region>
END

