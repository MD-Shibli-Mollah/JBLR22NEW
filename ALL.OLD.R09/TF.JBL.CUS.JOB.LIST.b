SUBROUTINE TF.JBL.CUS.JOB.LIST(Y.RETURN)
*-----------------------------------------------------------------------------
* WRITTEN BY ENAMUL HAQUE
*            FDS BD
*            10 JANUARY 2021
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    $INSERT I_ENQUIRY.COMMON
    $USING LC.Contract
    $USING LC.Config
    $USING ST.CompanyCreation
    
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.API
    $USING EB.Display
    $USING EB.Updates
    $USING EB.Foundation
    $USING EB.Reports
    $USING EB.LocalReferences
    
    $INSERT I_F.BD.BTB.JOB.REGISTER
    $INSERT I_F.BD.SCT.CAPTURE
    
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*-----------
INIT:
*-----------
    FN.DR = 'F.DRAWINGS'
    F.DR = ''
    
    FN.JOB.REG = 'F.BD.BTB.JOB.REGISTER'
    F.JOB.REG = ''
    
    FN.LC = 'F.LETTER.OF.CREDIT'
    F.LC = ''
    
    FN.LC.HIS = 'F.LETTER.OF.CREDIT$HIS'
    F.LC.HIS = ''
    
    FN.SCT = 'F.BD.SCT.CAPTURE'
    F.SCT = ''
        
    Y.DOC.AMOUNT = 0.00
RETURN
*-----------
OPENFILES:
*-----------
    Y.COMPANY = EB.SystemTables.getIdCompany()
    EB.DataAccess.Opf(FN.DR,F.DR)
    EB.DataAccess.Opf(FN.JOB.REG,F.JOB.REG)
    EB.DataAccess.Opf(FN.LC.HIS,F.LC.HIS)
    EB.DataAccess.Opf(FN.SCT,F.SCT)
RETURN
*---------
PROCESS:
*---------
    ! DEBUG
    LOCATE 'CUSTOMER.NO' IN EB.Reports.getEnqSelection()<2,1> SETTING CUS.POS THEN
        Y.CUS.NO= EB.Reports.getEnqSelection()<4,CUS.POS>
    END

    IF Y.CUS.NO NE '' THEN
        STMT='SELECT ':FN.JOB.REG:' WITH CUSTOMER.NO EQ ':Y.CUS.NO:' AND CO.CODE EQ ':Y.COMPANY:' BY @ID'
        EB.DataAccess.Readlist(STMT,REC,'',SIZE,ERR)
    END
    
    IF Y.CUS.NO EQ '' THEN
        STMT='SELECT ':FN.JOB.REG:' AND CO.CODE EQ ':Y.COMPANY:' BY @ID'
        EB.DataAccess.Readlist(STMT,REC,'',SIZE,ERR)
    END
    
    IF SIZE GT 0 THEN
        LOOP
            REMOVE Y.JOB.ID FROM REC SETTING POS
        WHILE Y.JOB.ID : POS
            EB.DataAccess.FRead(FN.JOB.REG,Y.JOB.ID,R.REC,F.JOB.REG,Y.ERR)
    
            ! Y.JOB.NO = R.REC<BTB.JOB.CO.CODE>  SL 2
            Y.CUS.ID = R.REC<BTB.JOB.CUSTOMER.NO>
            ! EX TF REF < ~~~ MULTI VALUE FIELD  ~~~ >  SL 3  :: SL 7
            Y.LC.REF = R.REC<BTB.JOB.EX.TF.REF>
            ! BTB.JOB.CONT.REFNO  < ~~~ MULTI VALUE FIELD  ~~~ >  SL 3
            Y.CONT.REF.NO = R.REC<BTB.JOB.CONT.REFNO>
            ! EXPORT LC NO   SL 4
            Y.EXP.LC.NO = R.REC<BTB.JOB.EX.LC.NUMBER>
            ! TOT PC AMT  SL 5
            Y.TOT.PC.AMT = R.REC<BTB.JOB.TOT.PC.ENT.AMT>
            ! TOT PC AVL AMT  SL 6
            Y.TOT.PC.AVL.AMT = R.REC<BTB.JOB.TOT.PC.AVL.AMT>
            ! Tot BTB Ent Amt   SL 8
            Y.TOT.BTB.ENT.AMT = R.REC<BTB.JOB.TOT.BTB.ENT.AMT>
            ! Tot BTB Avl Amt    SL 9
            Y.TOT.BTB.AVL.AMT = R.REC<BTB.JOB.TOT.BTB.AVL.AMT>
            ! Job Expiry Date  SL 10
            Y.TOT.JOB.EXP.DT = R.REC<BTB.JOB.JOB.EXPIRY.DATE>
          
            
            Y.LC.REF.SIZE = DCOUNT(Y.LC.REF,@VM)
            ! SALES CONTRACT TOTAL RECORD
            Y.SALES.CONT.SIZE = DCOUNT(Y.CONT.REF.NO,@VM)
            !!!!!!!!-----------F1--------------!!!!!!!!
            !DEBUG
            IF Y.LC.REF.SIZE GE 1 THEN
                !EX TF REF
                FOR I=1 TO Y.LC.REF.SIZE
                    IF I EQ 1 THEN
                        !Y.TEMP.EXP.VAL = Y.LC.REF<1,I>
                        !GOSUB TOT.DR.AMT
                        GOSUB SUM.OF.SCT.AND.EX.TF.REF
                        YY.LC.REF = Y.LC.REF<1,I>
                        !            1              2             3                4               5                  6                  7                  8                        9                  10
                        Y.DATA<-1>=Y.JOB.ID:'*':Y.CUS.ID:'*':YY.LC.REF:'*':Y.EXP.LC.NO:'*':Y.TOT.PC.AMT:'*':Y.TOT.PC.AVL.AMT:'*':Y.SUM.SCT.TF.AMT:'*':Y.TOT.BTB.ENT.AMT:'*':Y.TOT.BTB.AVL.AMT:'*':Y.TOT.JOB.EXP.DT
                        Y.DOC.AMOUNT=0
                    END
                    IF I GT 1 THEN
                        !Y.TEMP.EXP.VAL = Y.LC.REF<1,I>
                        !GOSUB TOT.DR.AMT
                        YY.LC.REF = Y.LC.REF<1,I>
                        !           1      2          3        4       5      6   7 Y.DOC.AMOUNT           8      9     10
                        Y.DATA<-1>='':'*':'':'*':YY.LC.REF:'*':'':'*':'':'*':'':'*':'':'*':'':'*':'':'*':''
                        Y.DOC.AMOUNT=0
                    END
                NEXT I
                IF Y.SALES.CONT.SIZE GE 1 THEN
                    FOR J=1 TO Y.SALES.CONT.SIZE
                        YY.CONT.REF.NO = Y.CONT.REF.NO<1,J>
                        GOSUB SCT.BANK.REFF.FLD
                        !!!!!      1       2          3                   4             5      6     7      8      9      10
                        Y.DATA<-1>='':'*':'':'*':YY.CONT.REF.NO:'*':Y.SCT.BNK.REFF:'*':'':'*':'':'*':'':'*':'':'*':'':'*':''
                    NEXT J
                END
            END
            ELSE
                !!!!!!---------F1-------!!!!!!!!!!!!!!!!!!!!!!!!
                IF Y.SALES.CONT.SIZE GE 1 THEN
                    FOR J=1 TO Y.SALES.CONT.SIZE
                        IF J EQ 1 THEN
                            GOSUB SUM.OF.SCT.AND.EX.TF.REF
                            YY.CONT.REF.NO = Y.CONT.REF.NO<1,J>
                            GOSUB SCT.BANK.REFF.FLD
                            !            1              2                3                4              5                  6              7: DOC.AMT               8                        9                  10
                            Y.DATA<-1>=Y.JOB.ID:'*':Y.CUS.ID:'*':YY.CONT.REF.NO:'*':Y.SCT.BNK.REFF:'*':Y.TOT.PC.AMT:'*':Y.TOT.PC.AVL.AMT:'*':Y.SUM.SCT.TF.AMT:'*':Y.TOT.BTB.ENT.AMT:'*':Y.TOT.BTB.AVL.AMT:'*':Y.TOT.JOB.EXP.DT
                        END
                        IF J GT 1 THEN
                            YY.CONT.REF.NO = Y.CONT.REF.NO<1,J>
                            GOSUB SCT.BANK.REFF.FLD
                            Y.DATA<-1>='':'*':'':'*':YY.CONT.REF.NO:'*':Y.SCT.BNK.REFF:'*':'':'*':'':'*':'':'*':'':'*':'':'*':''
                        END
                    NEXT J
                END
                ELSE
                    ! GOSUB SUM.OF.SCT.AND.EX.TF.REF
                    !            1              2         3      4               5          6           7: DOC.AMT               8                        9                  10
                    Y.DATA<-1>=Y.JOB.ID:'*':Y.CUS.ID:'*':'':'*':'':'*':Y.TOT.PC.AMT:'*':Y.TOT.PC.AVL.AMT:'*':'':'*':Y.TOT.BTB.ENT.AMT:'*':Y.TOT.BTB.AVL.AMT:'*':Y.TOT.JOB.EXP.DT
                END
            END
        REPEAT
    END
    Y.RETURN<-1> = Y.DATA
RETURN
*-------------------------
SUM.OF.SCT.AND.EX.TF.REF:
*-------------------------
    Y.SUM.SCT.TF.AMT=0
    FOR CC =1 TO Y.LC.REF.SIZE
        Y.TEMP= Y.LC.REF<1,CC>
        EB.DataAccess.FRead(FN.LC,Y.TEMP,LC.REC,F.LC,LC.ERR)
        IF LC.REC NE '' THEN
            Y.LC.AMT = LC.REC<LC.Contract.LetterOfCredit.TfLcLcAmount>
            Y.SUM.SCT.TF.AMT += Y.LC.AMT
        END
        ELSE
            !.DSND
            ! "SELECT ":FN.DR:" WITH @ID LIKE '":Y.LC.ID:"...' AND DRAWING.TYPE EQ 'SP' AND CO.CODE EQ ":ID.COMPANY
            !SEL.CMD = "SELECT ":FN.DR:" WITH @ID LIKE ":Y.LC.ID:"... AND DRAWING.TYPE EQ 'SP' AND CO.CODE EQ ":Y.COMPANY
            LC.HIS.STMT = "SELECT ":FN.LC.HIS:" WITH @ID LIKE ":Y.TEMP:"... AND CO.CODE EQ ":Y.COMPANY:" BY.DSND @ID"
            EB.DataAccess.Readlist(LC.HIS.STMT,Y.H.REC,'',Y.H.SIZE,Y.H.ERR)
            Y.Y.TEMP = Y.H.REC<1>
            
            EB.DataAccess.FRead(FN.LC.HIS,Y.Y.TEMP,L.LC.REC,F.LC.HIS,LC.ERR)
            Y.LC.AMT = L.LC.REC<LC.Contract.LetterOfCredit.TfLcLcAmount>
            Y.SUM.SCT.TF.AMT += Y.LC.AMT
        END
    NEXT CC
    FOR DD =1 TO Y.SALES.CONT.SIZE
        Y.TEMP.SCT.ID = Y.CONT.REF.NO<1,DD>
        EB.DataAccess.FRead(FN.SCT,Y.TEMP.SCT.ID,SCT.REC,F.SCT,SCT.ERR)
        Y.SCT.AMT = SCT.REC<SCT.CONTRACT.AMT>
        Y.SUM.SCT.TF.AMT += Y.SCT.AMT
    NEXT DD
RETURN
*------------------
SCT.BANK.REFF.FLD:
*-----------------
    !----  SCT.ISS.BANK.REF  ------------
    Y.SCT.ID = YY.CONT.REF.NO
    EB.DataAccess.FRead(FN.SCT,Y.SCT.ID,SCT.REC,F.SCT,SCT.ERR)
    Y.SCT.BNK.REFF = SCT.REC<SCT.ISS.BANK.REF>
RETURN
*----------------
END
