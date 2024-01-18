SUBROUTINE TF.JBL.I.OLDLC.NO.DEF
*-----------------------------------------------------------------------------
*Subroutine Description: Drawing and export collection update in AA
*Subroutine Type:
*Attached To    : activity api
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 04/03/2020 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
     
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING ST.Customer
    $USING EB.ErrorProcessing
    $USING AA.Framework
    $USING EB.LocalReferences
    $USING LC.Contract
    $USING AA.Account
    $USING EB.API
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
    
    
    EB.LocalReferences.GetLocRef('AA.ARR.ACCOUNT','LT.AC.DR.PUR.RN',Y.POS.1)
    EB.LocalReferences.GetLocRef('AA.ARR.ACCOUNT','LT.AC.BD.EXLCNO',Y.POS.2)
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.LC,F.LC)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    APP.NAME = 'AA.ARR.ACCOUNT'
    EB.API.GetStandardSelectionDets(APP.NAME, R.SS)
    Y.FIELD.NAME = 'LOCAL.REF'
    LOCATE Y.FIELD.NAME IN R.SS<AA.Account.Account.AcLocalRef> SETTING Y.POS THEN
    END
    CALL AA.GET.ACCOUNT.RECORD(R.PROPERTY.RECORD, PROPERTY.ID)
    TMP.DATA = R.PROPERTY.RECORD<1,Y.POS>
    
    Y.TF.NO = FIELD(TMP.DATA,SM,Y.POS.1)
    
    EB.DataAccess.FRead(FN.LC,Y.TF.NO,R.LC,F.LC,LC.ERR)
    
    IF R.LC THEN
        Y.OLD.LC.NUM = R.LC<LC.Contract.LetterOfCredit.TfLcOldLcNumber>
        Y.TEMPA = ""
        Y.TEMPA = EB.SystemTables.getRNew(AA.Account.Account.AcLocalRef)
        Y.TEMPA<1,Y.POS.2> = Y.OLD.LC.NUM
        EB.SystemTables.setRNew(AA.Account.Account.AcLocalRef,Y.TEMPA)
    END
RETURN
*** </region>

          
END