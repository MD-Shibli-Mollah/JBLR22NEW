SUBROUTINE TF.JBL.A.BTB.IMP.LC.OPENING
*-----------------------------------------------------------------------------
*Subroutine Description: BTB LC opening record write in BD.BTB.JOB.REGISTER
*Attached To    : LETTER.OF.CREDIT Version (LETTER.OF.CREDIT,JBL.BTBSIGHT. LLETTER.OF.CREDIT,JBL.BTBUSANCE, LETTER.OF.CREDIT,JBL.EDFOPEN)
*Attached As    : AUTH ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 07/11/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING LC.Contract
    $INSERT I_F.BD.BTB.JOB.REGISTER

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.LocalReferences
*-----------------------------------------------------------------------------
    IF EB.SystemTables.getVFunction() EQ 'A' THEN
	    GOSUB INITIALISE ; *INITIALISATION
	    GOSUB OPENFILE ; *FILE OPEN
	    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
    END
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.BD.BTB.JOB.REGISTER = 'F.BD.BTB.JOB.REGISTER'
    F.BD.BTB.JOB.REGISTER = ''
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.BD.BTB.JOB.REGISTER,F.BD.BTB.JOB.REGISTER)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    GOSUB GET.LOC.REF.POS
    Y.JOB.NUMBER = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.JOB.NO.POS>
    Y.BTB.LC.AMT = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcAmount)
    Y.USED.ENTAMT = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.USED.ENTAMT.POS>
    EB.DataAccess.FRead(FN.BD.BTB.JOB.REGISTER,Y.JOB.NUMBER,R.BTB.JOB.REGISTER,F.BD.BTB.JOB.REGISTER,Y.BD.JOB.REG.ERR)
    IF NOT(Y.BD.JOB.REG.ERR) THEN
        Y.ENT.AVAIL = R.BTB.JOB.REGISTER<BTB.JOB.TOT.BTB.AVL.AMT>
        Y.IMP.LC.REF = R.BTB.JOB.REGISTER<BTB.JOB.IM.TF.REF>
        IF NOT(Y.IMP.LC.REF) THEN
            Y.COUNT = "1"
            IF R.BTB.JOB.REGISTER<BTB.JOB.TOT.BTB.AMT> EQ "" THEN
                Y.TOT.BTB.LC.AMT = "0"
            END
            ELSE
                Y.TOT.BTB.LC.AMT = R.BTB.JOB.REGISTER<BTB.JOB.TOT.BTB.AMT>
            END
        END ELSE
            LOCATE EB.SystemTables.getIdNew() IN Y.IMP.LC.REF<1,1> SETTING Y.CNT.POS THEN
                Y.COUNT = Y.CNT.POS
                Y.TOT.BTB.LC.AMT = R.BTB.JOB.REGISTER<BTB.JOB.TOT.BTB.AMT> - R.BTB.JOB.REGISTER<BTB.JOB.IM.LC.AMOUNT,Y.COUNT>
                R.BTB.JOB.REGISTER<BTB.JOB.TOT.BTB.AVL.AMT> += R.BTB.JOB.REGISTER<BTB.JOB.IM.LC.AMOUNT,Y.COUNT>
            END ELSE
                Y.COUNT = DCOUNT(Y.IMP.LC.REF,@VM)
                Y.COUNT += 1
                Y.TOT.BTB.LC.AMT = R.BTB.JOB.REGISTER<BTB.JOB.TOT.BTB.AMT>
            END
        END
        GOSUB UPDATE.JOB.REGISTER
    END
RETURN
*** </region>

*** <region name= UPDATE.JOB.REGISTER>
UPDATE.JOB.REGISTER:
*** <desc>UPDATE.JOB.REGISTER </desc>
    R.BTB.JOB.REGISTER<BTB.JOB.IM.TF.REF,Y.COUNT> = EB.SystemTables.getIdNew()
    R.BTB.JOB.REGISTER<BTB.JOB.IM.BB.LC.NO,Y.COUNT> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcOldLcNumber)
    R.BTB.JOB.REGISTER<BTB.JOB.IM.LC.CURRENCY,Y.COUNT> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcCurrency)
    R.BTB.JOB.REGISTER<BTB.JOB.IM.LC.AMOUNT,Y.COUNT> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcAmount)
    R.BTB.JOB.REGISTER<BTB.JOB.IM.ISSUE.DATE,Y.COUNT> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcIssueDate)
    R.BTB.JOB.REGISTER<BTB.JOB.IM.EXPIRY.DATE,Y.COUNT> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcAdviceExpiryDate)
    IF EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcCurrency) NE R.BTB.JOB.REGISTER<BTB.JOB.JOB.CURRENCY> THEN
        R.BTB.JOB.REGISTER<BTB.JOB.TOT.BTB.AMT> = Y.USED.ENTAMT + Y.TOT.BTB.LC.AMT
        R.BTB.JOB.REGISTER<BTB.JOB.TOT.BTB.AVL.AMT> -= Y.USED.ENTAMT
    END ELSE
        R.BTB.JOB.REGISTER<BTB.JOB.TOT.BTB.AMT> = Y.BTB.LC.AMT + Y.TOT.BTB.LC.AMT
        R.BTB.JOB.REGISTER<BTB.JOB.TOT.BTB.AVL.AMT> -= Y.BTB.LC.AMT
    END
    
    EB.DataAccess.FWrite(FN.BD.BTB.JOB.REGISTER,Y.JOB.NUMBER,R.BTB.JOB.REGISTER)
RETURN
*** </region>

*** <region name= GET.LOC.REF.POS>
GET.LOC.REF.POS:
*** <desc>GET.LOC.REF.POS </desc>
    Y.JOB.NO.POS=''
    Y.JOB.ENT.POS=''
    Y.LC.AMT.LCY.POS = ''
    Y.ENT.PR.POS = ''
    Y.LC.AMT.POS = ''
    Y.EXCH.RATE.POS = ''

    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.JOB.NUMBR",Y.JOB.NO.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.BTB.ENTAM",Y.JOB.ENT.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.BTB.ENTRT",Y.ENT.PR.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.BTBUSE.EA",Y.USED.ENTAMT.POS)
RETURN
*** </region>


END
