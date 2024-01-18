SUBROUTINE TF.JBL.I.VERSION.NAME
*-----------------------------------------------------------------------------
*Subroutine Description: Version name wirte to LC
*Attached To    :
**************DRAWINGS,JBL.BTBAC
**************DRAWINGS,JBL.BTBDOCREJ
**************DRAWINGS,JBL.BTBLODGE
**************DRAWINGS,JBL.BTBMAT
**************DRAWINGS,JBL.BTBSHIPGTEE
**************DRAWINGS,JBL.BTBSP
**************DRAWINGS,JBL.BTBSP.T
**************DRAWINGS,JBL.EXMXPYMT
**************DRAWINGS,JBL.EXPAC
**************DRAWINGS,JBL.EXREGDISC
**************DRAWINGS,JBL.F.CONDOCREAL
**************DRAWINGS,JBL.F.EXPCOLL
**************DRAWINGS,JBL.F.EXPDOCREAL
**************DRAWINGS,JBL.F.PPMT.EXPDOCREAL
**************DRAWINGS,JBL.I.CONDOCREAL
**************DRAWINGS,JBL.I.EXPCOLL
**************DRAWINGS,JBL.I.EXPDOCREAL
**************DRAWINGS,JBL.I.PPMT.EXPDOCREAL
**************DRAWINGS,JBL.IMP.MXPYMT
**************DRAWINGS,JBL.IMPAC
**************DRAWINGS,JBL.IMPDOCREJ
**************DRAWINGS,JBL.IMPLODGE
**************DRAWINGS,JBL.IMPMAT
**************DRAWINGS,JBL.IMPMAT.PPMT
**************DRAWINGS,JBL.IMPSHIPGTEE
**************DRAWINGS,JBL.IMPSP
**************DRAWINGS,JBL.IMPSP.PPMT
**************DRAWINGS,JBL.IMPSP.T
**************DRAWINGS,JBL.INW.MESS
**************DRAWINGS,JBL.SALCSCOLL
**************EB.FREE.MESSAGE,JBL.INW.MESS
**************FUNDS.TRANSFER,JBL.EXP.PART.PAY.INFO
**************FUNDS.TRANSFER,JBL.IMP.PART.PAY.INFO
**************FUNDS.TRANSFER,JBL.INW.MESS
**************LETTER.OF.CREDIT,JBL.BTB.AMD.JOB
**************LETTER.OF.CREDIT,JBL.BTBAMDEXT
**************LETTER.OF.CREDIT,JBL.BTBAMDINT
**************LETTER.OF.CREDIT,JBL.BTBAMDINT.TEST
**************LETTER.OF.CREDIT,JBL.BTBCANCL
**************LETTER.OF.CREDIT,JBL.BTBRECORD
**************LETTER.OF.CREDIT,JBL.BTBRECORD.AMD
**************LETTER.OF.CREDIT,JBL.BTBSIGHT
**************LETTER.OF.CREDIT,JBL.BTBUSANCE
**************LETTER.OF.CREDIT,JBL.EDFOPEN
**************LETTER.OF.CREDIT,JBL.EXAMDEXT
**************LETTER.OF.CREDIT,JBL.EXAMDINT
**************LETTER.OF.CREDIT,JBL.EXLCTRF
**************LETTER.OF.CREDIT,JBL.EXPMXPMT
**************LETTER.OF.CREDIT,JBL.EXPSIGHT
**************LETTER.OF.CREDIT,JBL.EXPUSANCE
**************LETTER.OF.CREDIT,JBL.IMAMDEXT
**************LETTER.OF.CREDIT,JBL.IMAMDINT
**************LETTER.OF.CREDIT,JBL.IMPMGN.TAKE.RED
**************LETTER.OF.CREDIT,JBL.IMPMGNREL
**************LETTER.OF.CREDIT,JBL.IMPMXPMT
**************LETTER.OF.CREDIT,JBL.IMPSIGHT
**************LETTER.OF.CREDIT,JBL.IMPUSANCE
**************LETTER.OF.CREDIT,JBL.INW.MESS
**************LETTER.OF.CREDIT,JBL.SIPPMGNREL
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 23/10/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING LC.Contract
    $USING LD.Contract
    $USING EB.DataAccess
    $USING PD.Contract
    $USING MD.Contract
    $USING FT.Contract
    $USING EB.Versions
    $INSERT I_ENQUIRY.COMMON
    $USING EB.LocalReferences
    $USING EB.SystemTables

*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.LC='F.LETTER.OF.CREDIT'
    F.LC=''
    FN.DR='F.DRAWINGS'
    F.DR=''
    FN.LD='F.LD.LOANS.AND.DEPOSITS'
    F.LD=''
    FN.PD='F.PD.PAYMENT.DUE'
    F.PD=''
    FN.MD='F.MD.DEAL'
    F.MD=''

    FN.FT = 'F.FUNDS.TRANSFER'
    F.FT = ''

    Y.VERSION.NAME=''
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.VER.NAME",Y.LC.VER.NAME)
    EB.LocalReferences.GetLocRef("DRAWINGS","LT.TF.VER.NAME",Y.DR.VER.NAME)
    EB.LocalReferences.GetLocRef("LD.LOANS.AND.DEPOSITS","LT.TF.VER.NAME",Y.LD.VER.NAME)
    EB.LocalReferences.GetLocRef("PD.PAYMENT.DUE","LT.TF.VER.NAME",Y.PD.VER.NAME)
    EB.LocalReferences.GetLocRef("MD.DEAL","LT.TF.VER.NAME",Y.MD.VER.NAME)
    EB.LocalReferences.GetLocRef("FUNDS.TRANSFER","LT.TF.VER.NAME",Y.FT.VER.NAME)
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.LC,F.LC)
    EB.DataAccess.Opf(FN.DR,F.DR)
    EB.DataAccess.Opf(FN.LD,F.LD)
    EB.DataAccess.Opf(FN.PD,F.PD)
    EB.DataAccess.Opf(FN.MD,F.MD)
    EB.DataAccess.Opf(FN.FT,F.FT)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    BEGIN CASE
        CASE EB.SystemTables.getApplication() EQ 'LETTER.OF.CREDIT'
            Y.LC.ID= EB.SystemTables.getIdNew()
            CALL F.READ(FN.LC,Y.LC.ID,R.LC.REC,F.LC,Y.LC.ERR)
            Y.VERSION.NAME=FIELD(EB.SystemTables.getPgmVersion(),',',2)
            Y.TEMP = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
            Y.TEMP<1,Y.LC.VER.NAME> = Y.VERSION.NAME
            EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcLocalRef, Y.TEMP)
        CASE EB.SystemTables.getApplication() EQ 'DRAWINGS'
            Y.DR.ID=EB.SystemTables.getIdNew()
            CALL F.READ(FN.DR,Y.DR.ID,R.DR.REC,F.DR,Y.DR.ERR)
            Y.VERSION.NAME=FIELD(EB.SystemTables.getPgmVersion(),',',2)
            Y.TEMP = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)
            Y.TEMP<1,Y.DR.VER.NAME> = Y.VERSION.NAME
            EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrLocalRef, Y.TEMP)
        CASE EB.SystemTables.getApplication() EQ 'MD.DEAL'
            Y.MD.ID=EB.SystemTables.getIdNew()
            CALL F.READ(FN.MD,Y.MD.ID,R.MD.REC,F.MD,Y.MD.ERR)
            Y.VERSION.NAME=FIELD(EB.SystemTables.getPgmVersion(),',',2)
            Y.TEMP = EB.SystemTables.getRNew(MD.Contract.Deal.DeaLocalRef)
            Y.TEMP<1,Y.MD.VER.NAME> = Y.VERSION.NAME
            EB.SystemTables.setRNew(MD.Contract.Deal.DeaLocalRef, Y.TEMP)
        CASE EB.SystemTables.getApplication() EQ 'FUNDS.TRANSFER'
            Y.FT.ID=EB.SystemTables.getIdNew()
            CALL F.READ(FN.FT,Y.FT.ID,R.FT.REC,F.FT,Y.FT.ERR)
            Y.VERSION.NAME=FIELD(EB.SystemTables.getPgmVersion(),',',2)
            Y.TEMP = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
            Y.TEMP<1,Y.FT.VER.NAME> = Y.VERSION.NAME
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef, Y.TEMP)
    END CASE
RETURN
*** </region>
END
