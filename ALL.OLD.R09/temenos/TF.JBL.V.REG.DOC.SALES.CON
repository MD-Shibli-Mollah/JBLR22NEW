SUBROUTINE TF.JBL.V.REG.DOC.SALES.CON
*-----------------------------------------------------------------------------
*Attached VERSION    : LETTER.OF.CREDIT,BD.CDOS
*-----------------------------------------------------------------------------
* Modification History :
* 11/02/2020 -                            Creator   - MAHMUDUR RAHMAN (UDOY),
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
* Description: it read the data from Sales contact with validation Y.SCONT.ID
*              field and auto-populate LC fields from sales Contact application.
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BD.SCT.CAPTURE
    $USING LC.Contract
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.LocalReferences
    $USING EB.Updates
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
    
    FLD.POS = ''
    APPLICATION.NAME = 'LETTER.OF.CREDIT'
    LOCAL.FIELD = 'LT.TF.JOB.ENCUR':VM:'LT.TF.JOB.NUMBR':VM:'LT.TF.BTB.CNTNO'
    EB.Updates.MultiGetLocRef(APPLICATION.NAME,LOCAL.FIELD,FLD.POS)
    Y.JOB.CUR.POS = FLD.POS<1,1>
    Y.JOB.NUMBER.POS = FLD.POS<1,2>
    Y.CON.NUM.POS = FLD.POS<1,3>

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
        Y.CONT.CUR   = REC.SCT<SCT.CURRENCY>
        Y.CON.JOB.CUR = REC.SCT<SCT.JOB.CURRENCY>
        Y.CON.JOB.NUM = REC.SCT<SCT.BTB.JOB.NO>
        Y.CON.NUM = REC.SCT<SCT.CONTRACT.NUMBER>
        Y.TEMP = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
        Y.TEMP<1,Y.JOB.CUR.POS>    = Y.CON.JOB.CUR
        Y.TEMP<1,Y.JOB.NUMBER.POS> = Y.CON.JOB.NUM
        Y.TEMP<1,Y.CON.NUM.POS> = Y.CON.NUM
        EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcLocalRef,Y.TEMP)
        IF Y.BUYER.ID EQ "" THEN
            Y.BUYER.NAME   =   REC.SCT<SCT.BUYER.NAME>
            EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcApplicant,Y.BUYER.NAME)
        END
        ELSE
            EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcApplicantCustno,Y.BUYER.ID)
        END
        EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcLcCurrency,Y.CONT.CUR)
    END
RETURN
*** </region>
END
