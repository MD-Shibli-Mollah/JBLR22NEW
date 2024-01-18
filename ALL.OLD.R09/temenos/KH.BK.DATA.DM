    PROGRAM KH.BK.DATA.DM
    $INSERT GLOBUS.BP I_COMMON
    $INSERT GLOBUS.BP I_EQUATE
    $INSERT JBL.BP I_F.BD.SDSA.ENTRY.DETAILS
    $INSERT BP I_F.BD.BREAKUP

    FN.SDSA = 'F.BD.SDSA.ENTRY.DETAILS'
    F.SDSA = ''
    FN.BK = 'F.BD.BREAKUP'
    F.BK = ''
    Y.REF.NAME = ''
    CALL OPF(FN.SDSA,F.SDSA)
    CALL OPF(FN.BK,F.BK)

    SEL.CMD = 'SELECT ':FN.SDSA
    CALL EB.READLIST(SEL.CMD, SEL.LIST, F.SDSA, NO.OF.REC, RET.CODE)
    CRT "TOTAL RECORDS : " :NO.OF.REC
    CRT" Do You Want To Start The Processing of Breakup Entries Y/N"
    INPUT USER.CHOICE
    IF USER.CHOICE EQ 'Y' THEN
        LOOP
            REMOVE Y.ID FROM SEL.LIST SETTING POS
        WHILE Y.ID:POS
            CALL F.READ(FN.SDSA,Y.ID,R.SDSA,F.SDSA,SDSA.ERR)
            Y.AC = R.SDSA<BD.SDSA.AC.NUMBER>
            Y.CNT = DCOUNT(R.SDSA<BD.SDSA.ORG.TRANS.REF.NO>,@VM)
            Y.ORG.TT.FT = 'MIG'
            Y.AL = R.SDSA<BD.SDSA.AC.TYPE>
            Y.ORG.DRCR = FIELD(R.SDSA<BD.SDSA.ORG.DRCR>,@VM,1)
            Y.ORG.TRANS.CUR = FIELD(R.SDSA<BD.SDSA.ORG.TRANS.CUR>,@VM,1)
            Y.ORG.AMT = FIELD(R.SDSA<BD.SDSA.ORG.AMT>,@VM,1)
            Y.OUT.AMT = R.SDSA<BD.SDSA.OUTSTANDING.AMT>
            IF Y.OUT.AMT GT 0 THEN
!----------------Audit Data----------------------------
                Y.CURR.NO = 1
                Y.INPUTTER = FIELD(R.SDSA<BD.SDSA.INPUTTER>,'_',2)
                Y.DATE = TODAY
                Y.DATE1 = LEFT(Y.DATE,2)
                Y.DATE.TIME = Y.DATE1 : FIELD(R.SDSA<BD.SDSA.DATE.TIME>,@VM,1)
                Y.DATE.TIM = FIELD(R.SDSA<BD.SDSA.DATE.TIME>,@VM,1)
                Y.AUTHORISER = FIELD(R.SDSA<BD.SDSA.AUTHORISER>,@VM,1)
                Y.CO.CODE = R.SDSA<BD.SDSA.CO.CODE>
                Y.DEPT.CODE = R.SDSA<BD.SDSA.DEPT.CODE>
!-----------------Audit Data End ----------------------
                Y.BR.CODE = RIGHT(Y.CO.CODE,4)
                Y.ORG.ADJ = 'ORG'
!Y.DATE = TODAY
!Y.DATE.TIME1 = TIMEDATE ()
!Y.DATE.TIME2 = LEFT(Y.DATE.TIME1,8)
!Y.DATE.TIME3 = EREPLACE (Y.DATE.TIME2,':','')
!Y.D.TIME = Y.DATE : Y.DATE.TIME3

                Y.REF = UPCASE(Y.ID)
                FOR Z = 1 TO LEN(Y.REF)
                    Y.CH = Y.REF[Z,1]
                    IF ISALNUM(Y.CH) EQ 1 OR Y.CH EQ '.' THEN
                    END
                    ELSE Y.REF = EREPLACE (Y.REF,Y.CH,'.')
                NEXT Z

                Y.BK.ID = Y.AC:'*':Y.REF:'*': Y.DATE.TIME:'*':Y.BR.CODE:'*':Y.AL:'*':Y.ORG.DRCR:'*':Y.ORG.TT.FT:'*':Y.ORG.TRANS.CUR:'*':Y.OUT.AMT:'*':Y.ORG.ADJ
!---------------------WRITE---------------------------------
                CALL F.READ(FN.BK,Y.BK.ID,R.BK,F.BK,BK.ERR)
                IF R.BK EQ '' THEN
                    R.BK=''
                    R.BK<BD.BK.REF.NAME> = ''
                    R.BK<BD.BK.REF.DETAILS> = ''
                    R.BK<BD.BK.JBL.BK.ID> = ''
                    R.BK<BD.BK.CURR.NO> = '1'
                    R.BK<BD.BK.INPUTTER> = Y.INPUTTER
                    R.BK<BD.BK.DATE.TIME> = Y.DATE.TIM
                    R.BK<BD.BK.AUTHORISER> = Y.AUTHORISER
                    R.BK<BD.BK.CO.CODE> = Y.CO.CODE
                    R.BK<BD.BK.DEPT.CODE> = Y.DEPT.CODE
                    WRITE R.BK TO F.BK,Y.BK.ID
                END
            END
!---------------------WRITE END-----------------------------
            Y.CNT += 1
            CRT "Total Count : " : Y.CNT
            Y.D.TIME = ''
        REPEAT
    END
END
