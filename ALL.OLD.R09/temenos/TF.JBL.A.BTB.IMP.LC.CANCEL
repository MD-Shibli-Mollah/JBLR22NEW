SUBROUTINE TF.JBL.A.BTB.IMP.LC.CANCEL
*-----------------------------------------------------------------------------
*Subroutine Description: BTB Cancel data write in BD.BTB.JOB.REGISTER
*Attached To    : LETTER.OF.CREDIT Version (LETTER.OF.CREDIT,JBL.BTBCANCL)
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
    EB.DataAccess.FRead(FN.BD.BTB.JOB.REGISTER,Y.JOB.NUMBER,R.BTB.JOB.REGISTER,F.BD.BTB.JOB.REGISTER,Y.BD.JOB.REG.ERR)
    IF R.BTB.JOB.REGISTER THEN
        Y.IMP.LC.REF = R.BTB.JOB.REGISTER<BTB.JOB.IM.TF.REF>
        LOCATE EB.SystemTables.getIdNew() IN Y.IMP.LC.REF<1,1> SETTING Y.CNT.POS THEN
            Y.COUNT = Y.CNT.POS
            GOSUB UPDATE.JOB.REGISTER
        END
    END
RETURN
*** </region>


*** <region name= UPDATE.JOB.REGISTER>
UPDATE.JOB.REGISTER:
*** <desc>UPDATE.JOB.REGISTER</desc>
    Y.DEC.BTB.LCAMT = EB.SystemTables.getROld(LC.Contract.LetterOfCredit.TfLcLcAmount)
    R.BTB.JOB.REGISTER<BTB.JOB.IM.LC.AMOUNT,Y.COUNT> = 0
    R.BTB.JOB.REGISTER<BTB.JOB.TOT.BTB.AVL.AMT> += Y.DEC.BTB.LCAMT
*************************************Modification by erian@fortress-global.com*******DATE:20201024*****************
    R.BTB.JOB.REGISTER<BTB.JOB.TOT.BTB.AMT> -= Y.DEC.BTB.LCAMT
*************end************************Modification by erian@fortress-global.com*******DATE:20201024*****************
    EB.DataAccess.FWrite(FN.BD.BTB.JOB.REGISTER,Y.JOB.NUMBER,R.BTB.JOB.REGISTER)
RETURN
*** </region>
 

*** <region name= GET.LOC.REF.POS>
GET.LOC.REF.POS:
*** <desc>GET.LOC.REF.POS </desc>
    Y.JOB.NO.POS=''
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.JOB.NUMBR",Y.JOB.NO.POS)
RETURN
*** </region>

END
