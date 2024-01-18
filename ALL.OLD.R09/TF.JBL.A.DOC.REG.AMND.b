* @ValidationCode : Mjo2NzA1NDg3MTU6Q3AxMjUyOjE1NzQyNjIxMjcyNDc6REVMTDotMTotMTowOjA6ZmFsc2U6Ti9BOlIxN19BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 20 Nov 2019 21:02:07
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : DELL
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R17_AMR.0
SUBROUTINE TF.JBL.A.DOC.REG.AMND
*-----------------------------------------------------------------------------
*Subroutine Description: Contact Outward Colln Doc Details amend data write in BD.SCT.CAPTURE
*Attached To    : LETTER.OF.CREDIT,BD.OUTCOLL.AMD
*Attached As    : BEFORE.AUTH.RTN
*-----------------------------------------------------------------------------
* Modification History :
* 07/02/2020 -                            Created   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BD.SCT.CAPTURE
    $INSERT I_F.BD.BTB.JOB.REGISTER
*
    $USING LC.Contract
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.SystemTables
*
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
*-----
INIT:
*-----
    FN.JOB.REG = 'F.BD.BTB.JOB.REGISTER'
    F.JOB.REG = ''
*
    FN.SCT.CAP = 'F.BD.SCT.CAPTURE'
    F.SCT.CAP = ''
*
    FN.LC = 'F.LETTER.OF.CREDIT'
    F.LC  = ''
*
    FLD.POS = ''
RETURN
*----------
OPENFILES:
*----------
    EB.DataAccess.Opf(FN.JOB.REG,F.JOB.REG)
    EB.DataAccess.Opf(FN.SCT.CAP,F.SCT.CAP)
RETURN
*----------
PROCESS:
*----------
    Y.TF.ID = EB.SystemTables.getIdNew()
    APPLICATION.NAME = 'LETTER.OF.CREDIT'
    LOCAL.FIELD = 'LT.TF.SCONT.ID':VM:'LT.TF.JOB.NUMBR'
    EB.Updates.MultiGetLocRef(APPLICATION.NAME,LOCAL.FIELD,FLD.POS)
    Y.SCONT.ID.POS = FLD.POS<1,1>
    Y.JOB.NUMBER.POS = FLD.POS<1,2>
    Y.SCONT.ID.NEW = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.SCONT.ID.POS>
    Y.JOB.REG.ID.NEW = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.JOB.NUMBER.POS>

***********added by Huraira***********
    Y.LC.AMOUNT.NEW = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcAmount)
    Y.LC.AMOUNT.OLD = EB.SystemTables.getROld(LC.Contract.LetterOfCredit.TfLcLcAmount)
    Y.LC.AMOUNT.DIFF = Y.LC.AMOUNT.NEW - Y.LC.AMOUNT.OLD
    EB.DataAccess.FRead(FN.SCT.CAP,Y.SCONT.ID.NEW,R.SCONT.REC.CURR,F.SCT.CAP,E.SCT.CAP)
    R.SCONT.REC.CURR<SCT.COLL.AWAIT.AMT> += Y.LC.AMOUNT.DIFF
    WRITE R.SCONT.REC.CURR ON F.SCT.CAP,Y.SCONT.ID.NEW

***********end*********************
RETURN
END
