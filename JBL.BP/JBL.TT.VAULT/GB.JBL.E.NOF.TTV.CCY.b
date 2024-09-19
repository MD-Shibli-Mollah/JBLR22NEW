
SUBROUTINE GB.JBL.E.NOF.TTV.CCY(Y.RETURN)

*--------------------------------------------------------------------------------
* Subroutine Description:
*
* Attach To: STANDARD.SELECTION>NOFILE.JBL.TT.VAULT
* Attach As: NOFILE ROUTINE
*-----------------------------------------------------------------------------

* Modification History :  Retrofit from STANDARD.SELECTION>NOFILE.TT.VAULT - TTV.CCY
* 18/09/2024 -                             NEW -  MD SHIBLI MOLLAH
*                                                 NITSL Limited
*
* Currency Enquiry by Branch - E.TT.VAULT.CCY.BR - JBL.ENQ.TT.VAULT.CCY.BR
* STANDARD.SELECTION>NOFILE.TT.VAULT - TTV.CCY - NOFILE.JBL.TT.VAULT
* Currency Enquiry by HO Branch-Wise - E.TT.VAULT.CCY -  JBL.ENQ.TT.VAULT.CCY
* Currency Enquiry by HO Date-Wise - E.TT.VAULT.CCY.DT - JBL.ENQ.TT.VAULT.CCY.DT
* Cash Denomination Authorise - E.TT.VAULT.NAU - JBL.ENQ.TT.VAULT.NAU
**** E.TT.VAULT.BR ** NEED TO CHECK at R09
*
*--------------------------------------------------------------------------------
   
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.EB.JBL.TT.VAULT
    
    $USING EB.SystemTables
    $USING EB.Reports
    $USING EB.DataAccess
    $USING ST.Config
    
    Y.ID.COMPANY = EB.SystemTables.getIdCompany()
    Y.TODAY = EB.SystemTables.getToday()

    Y.ENQ = EB.Reports.getEnqSelection()<1,1>
    LOCATE 'Y.DATE' IN EB.Reports.getEnqSelection()<2,1> SETTING POS THEN
        TXN.DATE = EB.Reports.getEnqSelection()<4,POS>
        Y.TXN.DATE.OPD = EB.Reports.getEnqSelection()<3,POS>
    END
    LOCATE 'Y.AMT' IN EB.Reports.getEnqSelection()<2,1> SETTING POS1 THEN
        Y.SAMT = EB.Reports.getEnqSelection()<4,POS1>
        Y.SAMT.OPD = EB.Reports.getEnqSelection()<3,POS1>
    END
    ELSE
        Y.SAMT = ''
        Y.SAMT.OPD = 'EQ'
    END
    LOCATE 'Y.BR' IN EB.Reports.getEnqSelection()<2,1> SETTING POS2 THEN Y.BR.CODE = EB.Reports.getEnqSelection()<4,POS2>
    LOCATE 'Y.TYPE' IN EB.Reports.getEnqSelection()<2,1> SETTING POS3 THEN
        Y.STYPE = EB.Reports.getEnqSelection()<4,POS3>
        Y.STYPE.OPD = EB.Reports.getEnqSelection()<3,POS3>
    END
    ELSE
        Y.STYPE = ''
        Y.STYPE.OPD = 'EQ'
    END
    
    IF Y.BR.CODE EQ '' AND Y.ENQ EQ 'JBL.ENQ.TT.VAULT.CCY.BR' THEN Y.BR.CODE = Y.ID.COMPANY[6,4]
    IF Y.BR.CODE EQ '' AND (Y.ENQ EQ 'E.TT.VAULT.BR' OR Y.ENQ EQ 'JBL.ENQ.TT.VAULT.NAU') THEN Y.BR.CODE = Y.ID.COMPANY[6,4]
    IF Y.BR.CODE EQ '' AND Y.ENQ EQ 'JBL.ENQ.TT.VAULT.CCY' AND Y.ID.COMPANY NE 'BD0012001' THEN Y.BR.CODE = Y.ID.COMPANY[6,4]
    IF Y.ID.COMPANY NE 'BD0012001' AND Y.ENQ EQ 'JBL.ENQ.TT.VAULT.CCY.DT' THEN RETURN
    IF Y.ID.COMPANY NE 'BD0012001' AND Y.ENQ EQ 'JBL.ENQ.TT.VAULT.CCY' AND Y.ID.COMPANY[6,4] NE Y.BR.CODE THEN RETURN
    
    IF Y.TXN.DATE.OPD EQ 'EQ' AND (LEN(TXN.DATE) NE 8 OR NUM(TXN.DATE) EQ 0) THEN RETURN
    
    IF Y.TXN.DATE.OPD EQ 'RG' THEN
        IF COUNT(TXN.DATE,@SM) NE 1 THEN RETURN
        Y.TXN.DATE1 = FIELD(TXN.DATE,@SM,1)
        Y.TXN.DATE2 = FIELD(TXN.DATE,@SM,2)
        IF Y.TXN.DATE1 GT Y.TXN.DATE2 THEN
            Y.TEMP = Y.TXN.DATE1
            Y.TXN.DATE1 = Y.TXN.DATE2
            Y.TXN.DATE2 = Y.TEMP
        END
    END
    
    IF (Y.ENQ = 'JBL.ENQ.TT.VAULT.CCY.DT' OR Y.ENQ EQ 'E.TT.VAULT.BR') AND Y.TXN.DATE.OPD EQ 'EQ' THEN
        Y.TXN.DATE1 = TXN.DATE
        Y.TXN.DATE2 = TXN.DATE
    END
    IF Y.SAMT.OPD EQ 'RG' THEN
        IF COUNT(Y.SAMT,@SM) NE 1 THEN RETURN
        Y.SAMT1 = FIELD(Y.SAMT,@SM,1)
        Y.SAMT2 = FIELD(Y.SAMT,@SM,2)
        IF Y.SAMT1 GT Y.SAMT2 THEN
            Y.TEMP = Y.SAMT1
            Y.SAMT1 = Y.SAMT2
            Y.SAMT2 = Y.TEMP
        END
    END
    IF Y.STYPE.OPD EQ 'EQ' AND Y.STYPE EQ '' THEN Y.CUR.TYPE = 'FMNC'
    IF Y.STYPE.OPD EQ 'EQ' AND Y.STYPE NE '' THEN
        IF Y.STYPE EQ 'F' THEN Y.CUR.TYPE = 'F'
        IF Y.STYPE EQ 'M' THEN Y.CUR.TYPE = 'M'
        IF Y.STYPE EQ 'N' THEN Y.CUR.TYPE = 'N'
        IF Y.STYPE EQ 'C' THEN Y.CUR.TYPE = 'C'
    END
    IF Y.STYPE.OPD EQ 'RG' THEN
        IF COUNT(Y.STYPE,@SM) NE 1 THEN RETURN
        Y.STYPE1 = FIELD(Y.STYPE,@SM,1)
        Y.STYPE2 = FIELD(Y.STYPE,@SM,2)
        IF LEN(Y.STYPE1) NE 1 OR LEN(Y.STYPE2) NE 1 THEN RETURN
        IF Y.STYPE1 EQ Y.STYPE2 THEN Y.STYPE2 = ''
        IF Y.STYPE1 EQ 'F' THEN Y.CUR.TYPE = 'F'
        IF Y.STYPE1 EQ 'M' THEN Y.CUR.TYPE = 'M'
        IF Y.STYPE1 EQ 'N' THEN Y.CUR.TYPE = 'N'
        IF Y.STYPE1 EQ 'C' THEN Y.CUR.TYPE = 'C'
        IF Y.STYPE2 EQ 'F' THEN Y.CUR.TYPE = Y.CUR.TYPE:'F'
        IF Y.STYPE2 EQ 'M' THEN Y.CUR.TYPE = Y.CUR.TYPE:'M'
        IF Y.STYPE2 EQ 'N' THEN Y.CUR.TYPE = Y.CUR.TYPE:'N'
        IF Y.STYPE2 EQ 'C' THEN Y.CUR.TYPE = Y.CUR.TYPE:'C'
    END
    Y.CUR.CK = COUNT(Y.CUR.TYPE,'F') + COUNT(Y.CUR.TYPE,'M') +COUNT(Y.CUR.TYPE,'N') + COUNT(Y.CUR.TYPE,'C')
    IF Y.CUR.CK EQ 0 THEN RETURN

    FN.V = 'F.EB.JBL.TT.VAULT'
    IF Y.ENQ EQ 'JBL.ENQ.TT.VAULT.NAU' THEN FN.V = 'F.EB.JBL.TT.VAULT$NAU'
    F.V = ''
* CALL OPF(FN.V,F.V)
    EB.DataAccess.Opf(FN.V,F.V)

    FN.H = 'F.HOLD.CONTROL'
    F.H = ''
    EB.DataAccess.Opf(FN.H,F.H)

    IF Y.TXN.DATE.OPD EQ 'EQ' THEN
        IF Y.BR.CODE EQ '' THEN SEL.CMD = 'SELECT ':FN.V:' WITH @ID LIKE ...':TXN.DATE
        ELSE SEL.CMD = 'SELECT ':FN.V:' WITH @ID EQ ':Y.BR.CODE:'.':TXN.DATE
    END
    IF Y.TXN.DATE.OPD EQ 'RG' THEN SEL.CMD = 'SELECT ':FN.V:' WITH @ID LIKE ':Y.BR.CODE:'...'
    IF Y.TXN.DATE.OPD EQ '' THEN SEL.CMD = 'SELECT ':FN.V:' WITH @ID LIKE ':Y.BR.CODE:'...'

* CALL EB.READLIST(SEL.CMD, SEL.LIST, F.V, NO.OF.REC, RET.CODE)
* EB.DataAccess.Readlist(SelectStatement, KeyList, ListName, Selected, SystemReturnCode)
    EB.DataAccess.Readlist(SEL.CMD, SEL.LIST, F.V, NO.OF.REC, RET.CODE)
    SEL.LIST = SORT(SEL.LIST)

    FOR II = 1 TO NO.OF.REC
        Y.DETAILS = ''
        Y.F.DETAILS = ''
        Y.M.DETAILS = ''
        Y.N.DETAILS = ''
        Y.C.DETAILS = ''
        Y.F.UNIT = 0
        Y.M.UNIT = 0
        Y.N.UNIT = 0
        Y.C.UNIT = 0
        Y.T.AMT = 0
        IF Y.ENQ EQ 'JBL.ENQ.TT.VAULT.CCY.BR' OR Y.ENQ = 'JBL.ENQ.TT.VAULT.CCY' OR Y.ENQ EQ 'JBL.ENQ.TT.VAULT.NAU' OR ((Y.ENQ EQ 'JBL.ENQ.TT.VAULT.CCY.DT' OR Y.ENQ EQ 'E.TT.VAULT.BR') AND SEL.LIST<II>[6,8] GE Y.TXN.DATE1 AND SEL.LIST<II>[6,8] LE Y.TXN.DATE2) THEN
            IF Y.BR.CODE EQ '' OR Y.BR.CODE EQ SEL.LIST<II>[1,4] THEN

* CALL F.READ(FN.V,SEL.LIST<I>,R.CK,F.V,ERR.CK)
* EB.DataAccess.FRead(Fileid, VKey, Rec, FFileid, Er)
                EB.DataAccess.FRead(FN.V,SEL.LIST<II>,R.CK,F.V,ERR.CK)
                IF COUNT(Y.CUR.TYPE,'F') EQ 1 THEN
                    FOR JJ = 1 TO DCOUNT(R.CK<EB.TT.83.DENOM>,@VM)
                        Y.CUR = R.CK<EB.TT.83.DENOM><1,JJ>[4,LEN(R.CK<EB.TT.83.DENOM><1,JJ>)-3]
                        IF ((Y.SAMT.OPD EQ 'EQ' AND Y.SAMT EQ '') OR (Y.SAMT.OPD EQ 'EQ' AND Y.CUR EQ Y.SAMT) OR (Y.SAMT.OPD EQ 'RG' AND Y.CUR GE Y.SAMT1 AND Y.CUR LE Y.SAMT2)) AND R.CK<EB.TT.83.F.UNIT><1,JJ> GT 0 THEN
                            Y.F.UNIT = Y.F.UNIT + Y.CUR * R.CK<EB.TT.83.F.UNIT><1,JJ>
                            Y.TEMP = R.CK<EB.TT.83.DENOM><1,JJ>:' X ':R.CK<EB.TT.83.F.UNIT><1,JJ>:' = ':Y.CUR * R.CK<EB.TT.83.F.UNIT><1,JJ>
                            IF Y.F.DETAILS EQ '' THEN Y.F.DETAILS = Y.TEMP
                            ELSE
                                IF Y.ENQ NE 'JBL.ENQ.TT.VAULT.CCY.BR' THEN Y.F.DETAILS = Y.F.DETAILS:', ':Y.TEMP
                                ELSE Y.F.DETAILS = Y.F.DETAILS:@VM:Y.TEMP
                            END
                        END
                    NEXT JJ
                END
                IF Y.F.DETAILS NE '' THEN Y.DETAILS = 'Fresh Unit:':@VM:Y.F.DETAILS:@VM:'Total Amount: ':Y.F.UNIT
                IF COUNT(Y.CUR.TYPE,'M') EQ 1 THEN
                    FOR JJ = 1 TO DCOUNT(R.CK<EB.TT.83.DENOM>,@VM)
                        Y.CUR = R.CK<EB.TT.83.DENOM><1,JJ>[4,LEN(R.CK<EB.TT.83.DENOM><1,JJ>)-3]
                        IF ((Y.SAMT.OPD EQ 'EQ' AND Y.SAMT EQ '') OR (Y.SAMT.OPD EQ 'EQ' AND Y.CUR EQ Y.SAMT) OR (Y.SAMT.OPD EQ 'RG' AND Y.CUR GE Y.SAMT1 AND Y.CUR LE Y.SAMT2)) AND R.CK<EB.TT.83.M.UNIT><1,JJ> GT 0 THEN
                            Y.M.UNIT = Y.M.UNIT + Y.CUR * R.CK<EB.TT.83.M.UNIT><1,JJ>
                            Y.TEMP = R.CK<EB.TT.83.DENOM><1,JJ>:' X ':R.CK<EB.TT.83.M.UNIT><1,JJ>:' = ':Y.CUR * R.CK<EB.TT.83.M.UNIT><1,JJ>
                            IF Y.M.DETAILS EQ '' THEN Y.M.DETAILS = Y.TEMP
                            ELSE
                                IF Y.ENQ NE 'JBL.ENQ.TT.VAULT.CCY.BR' THEN Y.M.DETAILS = Y.M.DETAILS:', ':Y.TEMP
                                ELSE Y.M.DETAILS = Y.M.DETAILS:@VM:Y.TEMP
                            END
                        END
                    NEXT JJ
                END
                IF Y.M.DETAILS NE '' THEN
                    IF Y.DETAILS EQ '' THEN Y.DETAILS = 'Mutilated Unit:':@VM:Y.M.DETAILS:@VM:'Total Amount: ':Y.M.UNIT
                    ELSE Y.DETAILS = Y.DETAILS:@VM:' ':@VM:' ':@VM:'Mutilated Unit:':@VM:Y.M.DETAILS:@VM:'Total Amount: ':Y.M.UNIT
                END
                !----------------------START------------------------------------
                IF COUNT(Y.CUR.TYPE,'N') EQ 1 THEN
                    FOR JJ = 1 TO DCOUNT(R.CK<EB.TT.83.DENOM>,@VM)
                        Y.CUR = R.CK<EB.TT.83.DENOM><1,JJ>[4,LEN(R.CK<EB.TT.83.DENOM><1,JJ>)-3]
                        IF ((Y.SAMT.OPD EQ 'EQ' AND Y.SAMT EQ '') OR (Y.SAMT.OPD EQ 'EQ' AND Y.CUR EQ Y.SAMT) OR (Y.SAMT.OPD EQ 'RG' AND Y.CUR GE Y.SAMT1 AND Y.CUR LE Y.SAMT2)) AND R.CK<EB.TT.83.N.UNIT><1,JJ> GT 0 THEN
                            Y.N.UNIT = Y.N.UNIT + Y.CUR * R.CK<EB.TT.83.N.UNIT><1,JJ>
                            Y.TEMP = R.CK<EB.TT.83.DENOM><1,JJ>:' X ':R.CK<EB.TT.83.N.UNIT><1,JJ>:' = ':Y.CUR * R.CK<EB.TT.83.N.UNIT><1,JJ>
                            IF Y.N.DETAILS EQ '' THEN Y.N.DETAILS = Y.TEMP
                            ELSE
                                IF Y.ENQ NE 'JBL.ENQ.TT.VAULT.CCY.BR' THEN Y.N.DETAILS = Y.N.DETAILS:', ':Y.TEMP
                                ELSE Y.N.DETAILS = Y.N.DETAILS:@VM:Y.TEMP
                            END
                        END
                    NEXT JJ
                END
                IF Y.N.DETAILS NE '' THEN
                    IF Y.DETAILS EQ '' THEN Y.DETAILS = 'Non Issue Unit:':@VM:Y.N.DETAILS:@VM:'Total Amount: ':Y.N.UNIT
                    ELSE Y.DETAILS = Y.DETAILS:@VM:' ':@VM:' ':@VM:'Non Issue Unit:':@VM:Y.N.DETAILS:@VM:'Total Amount: ':Y.N.UNIT
                END
                !-----------------------------END----------------------------------------------

                IF COUNT(Y.CUR.TYPE,'C') EQ 1 THEN
                    FOR JJ = 1 TO DCOUNT(R.CK<EB.TT.83.DENOM>,@VM)
                        Y.CUR = R.CK<EB.TT.83.DENOM><1,JJ>[4,LEN(R.CK<EB.TT.83.DENOM><1,JJ>)-3]
                        IF ((Y.SAMT.OPD EQ 'EQ' AND Y.SAMT EQ '') OR (Y.SAMT.OPD EQ 'EQ' AND Y.CUR EQ Y.SAMT) OR (Y.SAMT.OPD EQ 'RG' AND Y.CUR GE Y.SAMT1 AND Y.CUR LE Y.SAMT2)) AND R.CK<EB.TT.83.COIN><1,JJ> GT 0 THEN
                            Y.C.UNIT = Y.C.UNIT + Y.CUR * R.CK<EB.TT.83.COIN><1,JJ>
                            Y.TEMP = R.CK<EB.TT.83.DENOM><1,JJ>:' X ':R.CK<EB.TT.83.COIN><1,JJ>:' = ':Y.CUR * R.CK<EB.TT.83.COIN><1,JJ>
                            IF Y.C.DETAILS EQ '' THEN Y.C.DETAILS = Y.TEMP
                            ELSE
                                IF Y.ENQ NE 'JBL.ENQ.TT.VAULT.CCY.BR' THEN Y.C.DETAILS = Y.C.DETAILS:', ':Y.TEMP
                                ELSE Y.C.DETAILS = Y.C.DETAILS:@VM:Y.TEMP
                            END
                        END
                    NEXT JJ
                END
                IF COUNT(Y.C.UNIT,'.') EQ 1 AND LEN(FIELD(Y.C.UNIT,'.',2)) EQ 1 THEN Y.C.UNIT = Y.C.UNIT : '0'
                IF Y.C.DETAILS NE '' THEN
                    IF Y.DETAILS EQ '' THEN Y.DETAILS = 'Coin Unit:':@VM:Y.C.DETAILS:@VM:'Total Amount: ':Y.C.UNIT
                    ELSE Y.DETAILS = Y.DETAILS:@VM:' ':@VM:' ':@VM:'Coin Unit:':@VM:Y.C.DETAILS:@VM:'Total Amount: ':Y.C.UNIT
                END
                Y.T.AMT = Y.F.UNIT + Y.M.UNIT +Y.N.UNIT + Y.C.UNIT
                IF COUNT(Y.T.AMT,'.') EQ 1 AND LEN(FIELD(Y.T.AMT,'.',2)) EQ 1 THEN Y.T.AMT = Y.T.AMT : '0'
                IF Y.ENQ EQ 'JBL.ENQ.TT.VAULT.NAU' THEN
                    Y.DT = '20':R.CK<EB.TT.83.DATE.TIME><1,1>[1,6]
                    Y.NDT = DATE() "D4/"
                    Y.NDT = FIELD(Y.NDT,'/',3):FIELD(Y.NDT,'/',1):FIELD(Y.NDT,'/',2)
                    IF Y.DT LT Y.NDT THEN Y.DETAILS = ''
                END
                IF Y.ENQ EQ 'E.TT.VAULT.BR' OR Y.ENQ EQ 'JBL.ENQ.TT.VAULT.NAU' AND Y.DETAILS NE '' THEN
                    Y.INPUTTER = FIELD(R.CK<EB.TT.83.INPUTTER><1,1>,'_',2)
                    Y.AUTHORISER = FIELD(R.CK<EB.TT.83.AUTHORISER><1,1>,'_',2)
                    Y.DT = R.CK<EB.TT.83.DATE.TIME><1,1>
                    Y.TIME = Y.DT[7,2]:':':Y.DT[9,2]
                    Y.DT1 = '20':Y.DT[1,6]
                    
* CALL DIETER.DATE(Y.DT1, Y.DT2, "D")
* ST.Config.DieterDate(DieterDate, PrimeDate, Conversion)
                    ST.Config.DieterDate(Y.DT1, Y.DT2, "D")
                    Y.DT = Y.DT2:' ':Y.TIME
                    Y.STATUS = R.CK<EB.TT.83.RECORD.STATUS>
                    Y.CIH = ''
                    IF SEL.LIST<II>[6,8] EQ Y.TODAY THEN
                        CALL NOFILE.DAYEND.CASH.MEMO.LOCAL(Y.CIH)
                        Y.CIH.CNT = DCOUNT(Y.CIH,@FM)
                        FOR KK = 1 TO Y.CIH.CNT
                            IF FIELD(Y.CIH<KK>,'*',1) EQ 'Closing Balance' THEN
                                Y.CIH = FIELD(Y.CIH<KK>,'*',2)
                                KK = Y.CIH.CNT
                            END
                        NEXT KK
                    END
                    ELSE
                        SEL.CMD = 'SELECT ':FN.H:' BY-DSND @ID WITH COMPANY.ID EQ BD001':SEL.LIST<II>[1,4]:' AND REPORT.NAME EQ ':'CRF.JBGL':' AND BANK.DATE EQ ':SEL.LIST<II>[6,8]
* CALL EB.READLIST(SEL.CMD, SEL.H, F.H, NO.OF.H, H.CODE)
                        EB.DataAccess.Readlist(SEL.CMD, SEL.H, F.H, NO.OF.H, H.CODE)
                        Y.LOG.DIR = '&HOLD&'
                        OPEN Y.LOG.DIR TO F.LOG.DIR ELSE STOP
                        Y.FILE = SEL.H<1>
                        READ Y.LOG FROM F.LOG.DIR,Y.FILE THEN
                            Y.LN.CNT = DCOUNT(Y.LOG,@FM)
                            FOR KK = 1 TO Y.LN.CNT
                                IF FIELD(Y.LOG<KK>,'TOTAL CASH IN HAND',2) NE '' THEN
                                    Y.CIH = FIELD(Y.LOG<KK>,'TOTAL CASH IN HAND',2)
                                    Y.CIH = EREPLACE (Y.CIH,',','')
                                    KK = Y.LN.CNT
                                END
                            NEXT KK
                        END
                    END
                END
                IF Y.DETAILS NE '' AND Y.ENQ EQ 'JBL.ENQ.TT.VAULT.CCY.BR' THEN Y.RETURN<-1> = SEL.LIST<II>[1,4]:'*':Y.DETAILS:'*':Y.T.AMT
                IF Y.DETAILS NE '' AND Y.ENQ EQ 'JBL.ENQ.TT.VAULT.CCY' THEN Y.RETURN<-1> = SEL.LIST<II>[1,4]:'*':Y.DETAILS:'*':Y.T.AMT
                IF Y.DETAILS NE '' AND Y.ENQ EQ 'JBL.ENQ.TT.VAULT.CCY.DT' THEN Y.RETURN<-1> = SEL.LIST<II>[6,8]:'*':Y.DETAILS:'*':Y.T.AMT
                IF Y.DETAILS NE '' AND Y.ENQ EQ 'E.TT.VAULT.BR' THEN Y.RETURN<-1> = SEL.LIST<II>:'*':Y.DETAILS:'*':Y.T.AMT:'*':Y.CIH:'*':Y.INPUTTER:'*':Y.AUTHORISER:'*':Y.DT
                IF Y.DETAILS NE '' AND Y.ENQ EQ 'JBL.ENQ.TT.VAULT.NAU' THEN Y.RETURN<-1> = SEL.LIST<II>:'*':Y.DETAILS:'*':Y.T.AMT:'*':Y.CIH:'*':Y.INPUTTER:'*':Y.STATUS:'*':Y.DT
            END
        END
    NEXT II
RETURN
END
