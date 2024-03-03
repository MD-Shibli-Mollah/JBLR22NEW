SUBROUTINE GB.JBL.E.NOF.MCD.MULTIPLE.VOUCHER(Y.DATA)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Developed By:
* Organization:
* Development Date:
*-----------------------------------------------------------------------------
*    SUBROUTINE MULTIPLE.VOUCHER(Y.DATA)
    !PROGRAM MULTIPLE.VOUCHER
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.RE.CONSOL.SPEC.ENTRY
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_F.CATEGORY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.JBL.H.MUL.MCD
*    $INSERT JBL.BP I_F.ABL.H.MUL.MCD

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING  AC.EntryCreation
    $USING  ST.Config
    $USING  AC.AccountOpening
    $USING  FT.Contract

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS

******
INIT:
******

    FN.CATEG = 'F.CATEGORY'
    F.CATEG = ''
    FN.AC = 'F.ACCOUNT'
    F.AC = ''
    FN.AC.HIS='F.ACCOUNT$HIS'
    F.AC.HIS=''
    FN.FT='F.FUNDS.TRANSFER'
    F.FT=''
    FN.FT.HIS='F.FUNDS.TRANSFER$HIS'
    F.FT.HIS=''
    FN.MCD='F.JBL.H.MUL.MCD'
    F.MCD=''


RETURN


***********
OPENFILES:
***********
    EB.DataAccess.Opf(FN.CATEG,F.CATEG)
    EB.DataAccess.Opf(FN.AC,F.AC)
    EB.DataAccess.Opf(FN.AC.HIS,F.AC.HIS)
    EB.DataAccess.Opf(FN.FT,F.FT)
    EB.DataAccess.Opf(FN.FT.HIS,F.FT.HIS)
    EB.DataAccess.Opf(FN.MCD,F.MCD)


RETURN

********
PROCESS:
********

    LOCATE 'ID' IN ENQ.SELECTION<2,1> SETTING ID.POS THEN
        Y.ID = ENQ.SELECTION<4,ID.POS>
    END

    EB.DataAccess.FRead(FN.MCD,Y.ID,R.MCD,F.MCD,ERR.MCD)

    Y.DR.FT=R.MCD<MCD.DR.FT.REF>
    Y.CR.FT=R.MCD<MCD.CR.FT.REF>

    FOR I=1 TO DCOUNT(Y.DR.FT,@VM)
        R.AC=''
        Y.FT.ID=FIELD(Y.DR.FT,@VM,I)

        EB.DataAccess.FRead(FN.FT,Y.FT.ID,R.FT,F.FT,ERR.FT)
        IF R.FT EQ '' THEN

            EB.DataAccess.FReadHistory(FN.FT.HIS,Y.FT.ID,R.FT,F.FT.HIS,ERR)
            Y.FT.ID=FIELD(Y.FT.ID,';',1)
        END

        Y.AC.ID=R.FT<FT.Contract.FundsTransfer.DebitAcctNo>
        IF LEFT(Y.AC.ID,2) NE 'PL' THEN
            EB.DataAccess.FRead(FN.AC,Y.AC.ID,R.AC,F.AC,Y.AC.ERR)
            IF R.AC EQ '' THEN
                EB.DataAccess.FReadHistory(FN.AC.HIS,Y.AC.ID,R.AC,F.AC.HIS,ERR)
            END
        END
        IF R.AC THEN
            Y.CATEG=R.AC<AC.AccountOpening.Account.Category>
            EB.DataAccess.FRead(FN.CATEG,Y.CATEG,R.CATEG,F.CATEG,Y.CATEG.ERR)
            Y.AC.TYPE = R.CATEG<ST.Config.Category.EbCatDescription>

            Y.AC.TITLE = R.AC<AC.AccountOpening.Account.AccountTitleOne>

        END ELSE
            Y.CATEG=RIGHT(Y.AC.ID,5)
            EB.DataAccess.FRead(FN.CATEG,Y.CATEG,R.CATEG,F.CATEG,Y.CATEG.ERR)

            Y.AC.TYPE = R.CATEG<ST.Config.Category.EbCatDescription>
            Y.AC.TITLE =R.CATEG<ST.Config.Category.EbCatDescription>
        END

        INT.DATE=ICONV(R.FT<FT.Contract.FundsTransfer.DebitValueDate>,"D")
        Y.VALUE.DATE =OCONV(INT.DATE, 'DD') "R%2":" ":OCONV(INT.DATE, 'DMA'):" ":OCONV(INT.DATE, 'DY4')
        Y.AMT=R.FT<FT.Contract.FundsTransfer.DebitAmount>
        LNGVAR=Y.AMT
*   CALL JBL.S.AMT.IN.WORDS(LNGVAR,TXTOUT)
*   Y.TXTOUT=TXTOUT
        Y.TXTOUT=''
        Y.AMT = FMT(Y.AMT,'R2,#18')
        Y.NARR=FIELD(R.MCD<MCD.DR.PAYMENT.DET>,@VM,I)
        Y.INPUTTER = FIELD(R.MCD<MCD.INPUTTER> ,'_',2,1)
        Y.AUTHOR = FIELD(R.MCD<MCD.AUTHORISER>,'_',2,1)
        IF R.AC THEN
            Y.DATA<-1> = 'Debit Voucher*':Y.ID:'*':Y.AC.ID:'*':Y.AC.TITLE:'*':Y.AC.TYPE:'*':Y.FT.ID:'*':Y.VALUE.DATE:'*':Y.AMT:'*':Y.TXTOUT:' Only*':Y.NARR:'*':Y.INPUTTER:'*':Y.AUTHOR
        END ELSE
            IF Y.CATEG GE 50000 AND Y.CATEG  LE 59999 THEN
                Y.DATA<-1> = 'Debit Voucher(Income)*':Y.ID:'*':Y.AC.ID:'*':Y.AC.TITLE:'*':Y.AC.TYPE:'*':Y.FT.ID:'*':Y.VALUE.DATE:'*':Y.AMT:'*':Y.TXTOUT:' Only*':Y.NARR:'*':Y.INPUTTER:'*':Y.AUTHOR
            END ELSE
                Y.DATA<-1> = 'Debit Voucher(Expenditure)*':Y.ID:'*':Y.AC.ID:'*':Y.AC.TITLE:'*':Y.AC.TYPE:'*':Y.FT.ID:'*':Y.VALUE.DATE:'*':Y.AMT:'*':Y.TXTOUT:' Only*':Y.NARR:'*':Y.INPUTTER:'*':Y.AUTHOR
            END
        END


    NEXT I

 
    FOR I=1 TO DCOUNT(Y.CR.FT,@VM)
        R.AC=''
        Y.FT.ID=FIELD(Y.CR.FT,@VM,I)
        EB.DataAccess.FRead(FN.FT,Y.FT.ID,R.FT,F.FT,ERR.FT)

        IF R.FT EQ '' THEN
            EB.DataAccess.FReadHistory(FN.FT.HIS,Y.FT.ID,R.FT,F.FT.HIS,ERR)
            Y.FT.ID=FIELD(Y.FT.ID,';',1)
        END
        Y.AC.ID=R.FT<FT.Contract.FundsTransfer.CreditAcctNo>

        IF LEFT(Y.AC.ID,2) NE 'PL' THEN
            EB.DataAccess.FRead(FN.AC,Y.AC.ID,R.AC,F.AC,Y.AC.ERR)
            IF R.AC EQ '' THEN

                EB.DataAccess.FReadHistory(FN.AC.HIS,Y.AC.ID,R.AC,F.AC.HIS,ERR)
            END
        END

        IF R.AC THEN
            Y.CATEG=R.AC<AC.AccountOpening.Account.Category>
            EB.DataAccess.FRead(FN.CATEG,Y.CATEG,R.CATEG,F.CATEG,Y.CATEG.ERR)
            Y.AC.TYPE = R.CATEG<ST.Config.Category.EbCatDescription>
            Y.AC.TITLE = R.AC<AC.AccountOpening.Account.AccountTitleOne>
        END ELSE

            Y.CATEG=RIGHT(Y.AC.ID,5)
            EB.DataAccess.FRead(FN.CATEG,Y.CATEG,R.CATEG,F.CATEG,Y.CATEG.ERR)
            Y.AC.TYPE = R.CATEG<ST.Config.Category.EbCatDescription>
            Y.AC.TITLE =R.CATEG<ST.Config.Category.EbCatDescription>
        END

        INT.DATE=ICONV(R.FT<FT.Contract.FundsTransfer.DebitValueDate>,"D")
        Y.VALUE.DATE =OCONV(INT.DATE, 'DD') "R%2":" ":OCONV(INT.DATE, 'DMA'):" ":OCONV(INT.DATE, 'DY4')
        Y.AMT=R.FT<FT.Contract.FundsTransfer.DebitAmount>
        LNGVAR=Y.AMT
***       CALL JBL.S.AMT.IN.WORDS(LNGVAR,TXTOUT)
*        Y.TXTOUT=TXTOUT
        Y.TXTOUT=''
        Y.AMT = FMT(Y.AMT,'R2,#18')
        Y.NARR=FIELD(R.MCD<MCD.CR.PAYMENT.DET>,@VM,I)
        Y.INPUTTER = FIELD(R.MCD<MCD.INPUTTER> ,'_',2,1)
        Y.AUTHOR = FIELD(R.MCD<MCD.AUTHORISER>,'_',2,1)
        IF R.AC THEN
            Y.DATA<-1> = 'Credit Voucher*':Y.ID:'*':Y.AC.ID:'*':Y.AC.TITLE:'*':Y.AC.TYPE:'*':Y.FT.ID:'*':Y.VALUE.DATE:'*':Y.AMT:'*':Y.TXTOUT:' Only*':Y.NARR:'*':Y.INPUTTER:'*':Y.AUTHOR
        END ELSE
            IF Y.CATEG GE 50000 AND Y.CATEG LE 59999 THEN
                Y.DATA<-1> = 'Credit Voucher(Income)*':Y.ID:'*':Y.AC.ID:'*':Y.AC.TITLE:'*':Y.AC.TYPE:'*':Y.FT.ID:'*':Y.VALUE.DATE:'*':Y.AMT:'*':Y.TXTOUT:' Only*':Y.NARR:'*':Y.INPUTTER:'*':Y.AUTHOR
            END ELSE
                Y.DATA<-1> = 'Credit Voucher(Expenditure)*':Y.ID:'*':Y.AC.ID:'*':Y.AC.TITLE:'*':Y.AC.TYPE:'*':Y.FT.ID:'*':Y.VALUE.DATE:'*':Y.AMT:'*':Y.TXTOUT:' Only*':Y.NARR:'*':Y.INPUTTER:'*':Y.AUTHOR
            END

        END

    NEXT I

RETURN
*    END
END
*   END
