
SUBROUTINE GB.JBL.E.NOF.TTV.BR(Y.RETURN)
    
*--------------------------------------------------------------------------------
* Subroutine Description:
*
* Attach To: STANDARD.SELECTION>NOFILE.JBL.TT.VAULT.BR
* Attach As: NOFILE ROUTINE
*-----------------------------------------------------------------------------

* Modification History :  Retrofit from STANDARD.SELECTION>NOFILE.TT.VAULT.BR - TTV.BR
* 18/09/2024 -                             NEW -  MD SHIBLI MOLLAH
*                                                 NITSL Limited
* Inactive Branch List Enquiry by HO - E.TT.VAULT.IBR - JBL.ENQ.TT.VAULT.IBR
* Active Branch List Enquiry by HO - E.TT.VAULT.ABR - JBL.ENQ.TT.VAULT.ABR
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
    $USING ST.CompanyCreation

    Y.ID.COMPANY = EB.SystemTables.getIdCompany()
    
    IF Y.ID.COMPANY NE 'BD0012001' THEN RETURN

    Y.ENQ = EB.Reports.getEnqSelection()<1,1>
    LOCATE 'Y.DATE' IN EB.Reports.getEnqSelection()<2,1> SETTING POS THEN TXN.DATE = EB.Reports.getEnqSelection()<4,POS>
    IF LEN(TXN.DATE) NE 8 OR NUM(TXN.DATE) EQ 0 THEN RETURN

    FN.V = 'F.TT.VAULT'
    F.V = ''
    FN.CO = 'F.COMPANY'
    F.CO =''
    EB.DataAccess.Opf(FN.CO,F.CO)
    EB.DataAccess.Opf(FN.V,F.V)

    SEL.CMD = 'SELECT ':FN.V:' WITH @ID LIKE ...':TXN.DATE
    EB.DataAccess.Readlist(SEL.CMD, SEL.V, F.V, NO.OF.V, V.RET.CODE)
    IF Y.ENQ EQ 'JBL.ENQ.TT.VAULT.IBR' THEN
        SEL.CMD = 'SELECT ':FN.CO:' WITH @ID LIKE BD001...'
        EB.DataAccess.Readlist(SEL.CMD, SEL.CO, F.CO, NO.OF.CO, CO.RET.CODE)
        SEL.CO = SORT(SEL.CO)

        FOR II = 1 TO NO.OF.CO
            Y.CUR = SEL.CO<II>[6,4]:'.':TXN.DATE
            IF COUNT(SEL.V,Y.CUR) EQ 0 AND SEL.CO<II> NE 'BD0015051' AND SEL.CO<II> NE 'BD0019999' THEN
                EB.DataAccess.FRead(FN.CO,SEL.CO<II>,R.CK,F.CO,ERR.CK)
                Y.LOC = ''
* FOR JJ = 1 TO DCOUNT(R.CK<EB.COM.NAME.ADDRESS>,@VM)
                FOR JJ = 1 TO DCOUNT(R.CK<ST.CompanyCreation.Company.EbComNameAddress>,@VM)
                    IF Y.LOC EQ '' THEN Y.LOC = FIELD(R.CK<ST.CompanyCreation.Company.EbComNameAddress>,@VM,JJ)
                    ELSE Y.LOC = Y.LOC:' ': FIELD(R.CK<ST.CompanyCreation.Company.EbComNameAddress>,@VM,JJ)
                NEXT JJ
* R.CK<EB.COM.APPLICATIONS> * EB.COM.COMPANY.NAME
                IF COUNT(R.CK<ST.CompanyCreation.Company.EbComApplications>,'TT') EQ 1 THEN Y.RETURN<-1> = SEL.CO<II>[6,4]:'*':R.CK<ST.CompanyCreation.Company.EbComCompanyName>:'*':Y.LOC
            END
        NEXT II
    END
    IF Y.ENQ EQ 'JBL.ENQ.TT.VAULT.ABR' THEN
        FOR II = 1 TO NO.OF.V
            EB.DataAccess.FRead(FN.CO,'BD001':SEL.V<II>[1,4],R.CK,F.CO,ERR.CK)
            Y.LOC = ''
            FOR JJ = 1 TO DCOUNT(R.CK<ST.CompanyCreation.Company.EbComNameAddress>,@VM)
                IF Y.LOC EQ '' THEN Y.LOC = FIELD(R.CK<ST.CompanyCreation.Company.EbComNameAddress>,@VM,JJ)
                ELSE Y.LOC = Y.LOC:' ': FIELD(R.CK<ST.CompanyCreation.Company.EbComNameAddress>,@VM,JJ)
            NEXT JJ
            IF COUNT(R.CK<ST.CompanyCreation.Company.EbComApplications>,'TT') EQ 1 THEN Y.RETURN<-1> = SEL.V<II>[1,4]:'*':R.CK<ST.CompanyCreation.Company.EbComCompanyName>:'*':Y.LOC
        NEXT II
    END
RETURN
END
