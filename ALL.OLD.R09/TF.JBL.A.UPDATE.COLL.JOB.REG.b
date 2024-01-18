SUBROUTINE TF.JBL.A.UPDATE.COLL.JOB.REG
*-----------------------------------------------------------------------------
*Subroutine Description: Job register update for CO type export drawings
*Subroutine Type:
*Attached To    : LETTER.OF.CREDIT Version (DRAWINGS,BD.F.EXPCOLL)
*Attached As    : AUTH ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 24/10/2019 -                            Retrofit   - MD.KAMRUL HASAN
*                                                 FDS Pvt Ltd
*-----------------------------------------------------------------------------
    $INCLUDE  I_COMMON
    $INCLUDE  I_EQUATE
    $INCLUDE  I_F.DRAWINGS
    $INCLUDE  I_F.BD.BTB.JOB.REGISTER
    $INCLUDE  I_F.BD.EXPFORM.REGISTER
    $USING LC.Contract
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.LocalReferences
    $USING EB.TransactionControl

    IF EB.SystemTables.getVFunction() EQ "A" THEN
        GOSUB INITIALISE
        GOSUB PROCESS
    END
RETURN

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.DRAWINGS = 'F.DRAWINGS'
    F.DRAWINGS = ''
    EB.DataAccess.Opf(FN.DRAWINGS,F.DRAWINGS)
    R.DRAWINGS = ''
    Y.DRAWINGS.ERR = ''

    FN.BD.BTB.JOB.REGISTER = 'F.BD.BTB.JOB.REGISTER'
    F.BD.BTB.JOB.REGISTER = ''
    EB.DataAccess.Opf(FN.BD.BTB.JOB.REGISTER,F.BD.BTB.JOB.REGISTER)
    R.BD.BTB.JOB.REGISTER = ''

    FN.EXPFORM = 'F.BD.EXPFORM.REGISTER'
    F.EXPFORM = ''
    EB.DataAccess.Opf(FN.EXPFORM,F.EXPFORM)
    R.EXPFORM.REC = ''
    Y.EXPFORM.ERR = ''

    Y.EXPFORM.NO = ''
    Y.JOB.NO = ''
    Y.DR.ID = ''
    Y.LC.ID = ''
    Y.COUNT = ''
    Y.COUNT.POS = ''
    Y.EX.DR.NO = ''
    Y.DR.CNT = ''
    Y.EXP.CNT = ''

RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    GOSUB GET.LOC.REF.POS
    GOSUB UPDATE.JOB.REGISTER
    GOSUB UPDATE.EXP.REGISTER
RETURN

*-----------------------------------------------------------------------------
UPDATE.JOB.REGISTER:
*--------------
    Y.JOB.NO =  EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1,Y.DR.JOBNO.POS>
    Y.DR.ID =EB.SystemTables.getIdNew()
    Y.LC.ID = Y.DR.ID[1,12]
    IF Y.JOB.NO EQ '' THEN RETURN
    EB.DataAccess.FRead(FN.BD.BTB.JOB.REGISTER,Y.JOB.NO,R.BTB.JOB.REGISTER,F.BD.BTB.JOB.REGISTER,R.BTB.JOB.REG.ERR)
    Y.EX.TF.NO = R.BTB.JOB.REGISTER<BTB.JOB.EX.TF.REF>
    LOCATE Y.LC.ID IN Y.EX.TF.NO<1,1> SETTING Y.COUNT.POS THEN
        Y.COUNT = Y.COUNT.POS
        Y.EX.DR.NO = R.BTB.JOB.REGISTER<BTB.JOB.EX.DR.ID,Y.COUNT>
        LOCATE Y.DR.ID IN Y.EX.DR.NO<1,1> SETTING Y.DR.CNT.POS THEN
            Y.DR.CNT=Y.DR.CNT.POS
            R.BTB.JOB.REGISTER<BTB.JOB.EX.DR.AMT,Y.COUNT,Y.DR.CNT>=EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrDocumentAmount)
            R.BTB.JOB.REGISTER<BTB.JOB.TOT.EX.LC.DRAW.AMT> += EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrDocumentAmount)
            EB.DataAccess.FWrite(FN.BD.BTB.JOB.REGISTER, Y.JOB.NO, R.BTB.JOB.REGISTER)
            EB.TransactionControl.JournalUpdate('')
            SENSITIVITY = ''
*WRITE R.BTB.JOB.REGISTER TO F.BD.BTB.JOB.REGISTER, Y.JOB.NO
        END ELSE
            Y.DR.CNT = DCOUNT(R.BTB.JOB.REGISTER<BTB.JOB.EX.DR.ID,Y.COUNT>,@SM) + 1
            R.BTB.JOB.REGISTER<BTB.JOB.EX.DR.ID,Y.COUNT,Y.DR.CNT>=EB.SystemTables.getIdNew()
            R.BTB.JOB.REGISTER<BTB.JOB.EX.DR.AMT,Y.COUNT,Y.DR.CNT>=EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrDocumentAmount)
            R.BTB.JOB.REGISTER<BTB.JOB.TOT.EX.LC.DRAW.AMT> += EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrDocumentAmount)
            EB.DataAccess.FWrite(FN.BD.BTB.JOB.REGISTER, Y.JOB.NO, R.BTB.JOB.REGISTER)
            EB.TransactionControl.JournalUpdate('')
            SENSITIVITY = ''
*WRITE R.BTB.JOB.REGISTER TO F.BD.BTB.JOB.REGISTER, Y.JOB.NO
        END
    END
RETURN

*-----------------------------------------------------------------------------
UPDATE.EXP.REGISTER:
*------------------
    IF EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1,Y.DR.EXPNO.POS> EQ "" THEN RETURN
    Y.EXP.CNT = DCOUNT(EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1,Y.DR.EXPNO.POS>,@SM)
    IF Y.EXP.CNT GE 1 THEN
        FOR I = 1 TO Y.EXP.CNT
            Y.EXPFORM.NO = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1,Y.DR.EXPNO.POS,I>
            EB.DataAccess.FRead(FN.EXPFORM,Y.EXPFORM.NO,R.EXPFORM.REC,F.EXPFORM,Y.EXPFORM.ERR)
            R.EXPFORM.REC<EXPFORM.DRAWING.NO> = EB.SystemTables.getIdNew()
            EB.DataAccess.FWrite(FN.EXPFORM, Y.EXPFORM.NO, R.EXPFORM.REC)
            EB.TransactionControl.JournalUpdate('')
            SENSITIVITY = ''
*WRITE R.EXPFORM.REC TO F.EXPFORM, Y.EXPFORM.NO
            Y.EXPFORM.NO = ''
            R.EXPFORM.REC = ''
        NEXT I
    END
RETURN
*-----------------------------------------------------------------------------
GET.LOC.REF.POS:
*--------------
    EB.LocalReferences.GetLocRef("DRAWINGS","LT.TF.JOB.NUMBR",Y.DR.JOBNO.POS)
    EB.LocalReferences.GetLocRef("DRAWINGS","LT.TF.EXP.FM.NO",Y.DR.EXPNO.POS)
RETURN
END
