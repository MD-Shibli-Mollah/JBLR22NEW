* @ValidationCode : Mjo4NTQ1MTg4MDk6Q3AxMjUyOjE1NzI1MTk3NjE1Nzc6REVMTDotMTotMTowOjA6ZmFsc2U6Ti9BOlIxN19BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 Oct 2019 17:02:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : DELL
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R17_AMR.0
SUBROUTINE TF.JBL.A.DOC.REG.CONT.JOB.UPD
*-----------------------------------------------------------------------------
*Subroutine Description: Lodge Document Against Sales Contract data update in Job register
*Attached To    : LETTER.OF.CREDIT,BD.CDOS
*Attached As    : AUTH ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 07/02/2020 -                            Created   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING LC.Contract
    $USING EB.Updates

    $INSERT I_F.BD.SCT.CAPTURE
    $INSERT I_F.BD.BTB.JOB.REGISTER
    $INSERT I_F.LETTER.OF.CREDIT
*-----------------------------------------------------------------------------
    IF EB.SystemTables.getVFunction() EQ 'A' THEN
        GOSUB INIT
        GOSUB OPENFILES
        GOSUB PROCESS
    END
RETURN

*****
INIT:
*****
    FN.JOB.REG = 'F.BD.BTB.JOB.REGISTER'
    F.JOB.REG = ''
    FN.SCT.CAP = 'F.BD.SCT.CAPTURE'
    F.SCT.CAP = ''
    FLD.POS = ''
    APPLICATION.NAME = 'LETTER.OF.CREDIT'
    LOCAL.FIELD = 'LT.TF.SCONT.ID':VM:'LT.TF.JOB.NUMBR':VM:'LT.TF.JOB.ENCUR'
    EB.Updates.MultiGetLocRef(APPLICATION.NAME,LOCAL.FIELD,FLD.POS)
    Y.SCONT.ID.POS = FLD.POS<1,1>
    Y.JOB.NUMBER.POS = FLD.POS<1,2>
    Y.JOB.CURR.POS = FLD.POS<1,3>
    
    Y.DOC.ID = EB.SystemTables.getIdNew()
    Y.LC.AMOUNT = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcAmount)
    Y.SCONT.ID = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.SCONT.ID.POS>
    Y.JOB.REG.ID = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.JOB.NUMBER.POS>
RETURN

***********
OPENFILES:
***********
    EB.DataAccess.Opf(FN.JOB.REG,F.JOB.REG)
    EB.DataAccess.Opf(FN.SCT.CAP,F.SCT.CAP)
RETURN

********
PROCESS:
********
********Update(Awaiting Amoount,Collection TF ID and fully utilized field) in BD.SCT.CAPTURE Record********************************
    EB.DataAccess.FRead(FN.SCT.CAP,Y.SCONT.ID,R.SCONT.REC,F.SCT.CAP,E.SCT.CAP)
    IF R.SCONT.REC THEN
        Y.AWAIT.AMT = R.SCONT.REC<SCT.COLL.AWAIT.AMT> + Y.LC.AMOUNT
        Y.SCT.AMT = R.SCONT.REC<SCT.CONTRACT.AMT>
        Y.COLL.TF.NO = R.SCONT.REC<SCT.COLL.TF.ID>
        IF Y.AWAIT.AMT GE Y.SCT.AMT THEN
            R.SCONT.REC<SCT.FULLY.UTILIZED.YN> = 'YES'
        END
        FINDSTR Y.DOC.ID  IN Y.COLL.TF.NO SETTING Y.DOC.ID.POS ELSE NULL
        IF Y.DOC.ID.POS EQ '' THEN
            Y.COUNT = DCOUNT(Y.COLL.TF.NO,VM) + 1
            R.SCONT.REC<SCT.COLL.TF.ID,Y.COUNT> = Y.DOC.ID
        END
        R.SCONT.REC<SCT.COLL.AWAIT.AMT> = Y.AWAIT.AMT
*   WRITE R.SCONT.REC ON F.SCT.CAP,Y.SCONT.ID
        EB.DataAccess.FWrite(FN.SCT.CAP,Y.SCONT.ID,R.SCONT.REC)
    END
********End Update BD.SCT.CAPTURE Record********************************

********Update(Collection TF refno) in BD.BTB.JOB.REGISTER Record**************************************
    EB.DataAccess.FRead(FN.JOB.REG,Y.JOB.REG.ID,R.JOB.REG,F.JOB.REG,E.JOB.REG)
    IF R.JOB.REG THEN
        Y.JOB.SCONT = R.JOB.REG<BTB.JOB.CONT.REFNO>
        FIND Y.SCONT.ID IN Y.JOB.SCONT SETTING Y.SCONT.ID.POS1, Y.SCONT.ID.POS2, Y.SCONT.ID.POS3 THEN
            Y.JOB.COLL.TF.REFNO = R.JOB.REG<BTB.JOB.COLL.TF.REFNO, Y.SCONT.ID.POS2>
            FIND Y.DOC.ID  IN Y.JOB.COLL.TF.REFNO SETTING Y.JOB.COLL.TF.POS1, Y.JOB.COLL.TF.POS2, Y.JOB.COLL.TF.POS3  ELSE NULL
            IF Y.JOB.COLL.TF.POS3 EQ '' THEN
                Y.COUNT.JOB = DCOUNT(Y.JOB.COLL.TF.REFNO, SM) + 1
                R.JOB.REG<BTB.JOB.COLL.TF.REFNO, Y.SCONT.ID.POS2, Y.COUNT.JOB> = Y.DOC.ID
            END
        END
*   WRITE R.JOB.REG ON F.JOB.REG,Y.JOB.REG.ID
        EB.DataAccess.FWrite(FN.JOB.REG,Y.JOB.REG.ID,R.JOB.REG)
    END
********End Update BD.BTB.JOB.REGISTER Record**************************************
RETURN
END
